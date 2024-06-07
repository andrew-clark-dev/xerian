import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xerian/models/Category.dart' as models;
import 'package:xerian/services/counter_service.dart';
import 'package:xerian/services/row_service.dart';
import 'package:xerian/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../routable.dart';

class CategoryListView extends StatefulWidget implements Routable {
  const CategoryListView({super.key});

  @override
  String get path => '/Categorys';

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  List<models.Category> _categorys = <models.Category>[];

  final NumberFormat formatter = NumberFormat("00000000");

  // Define variables for managing list data and scrolling
  final ScrollController _scrollController = ScrollController();
  // Method to add more data when scrolling reaches the end
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _refreshCategorys();
    }
  }

  @override
  void initState() {
    super.initState();
    CounterService.initialize();
    _refreshCategorys();
    // Attach listener to scroll controller
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _refreshCategorys() async {
    try {
      final request = ModelQueries.list(models.Category.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        final categorys = response.data?.items;
        _categorys = categorys!.whereType<models.Category>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  Future<void> _deleteCategory(models.Category category) async {
    final request = ModelMutations.delete<models.Category>(category);
    final response = await Amplify.API.mutate(request: request).response;
    safePrint('Delete response: $response');
    await _refreshCategorys();
  }

  Future<void> _navigateToCategory({models.Category? category}) async {
    context.push('/Category', extra: Category);
    // Refresh the entries when returning from Category detail screen.
    await _refreshCategorys();
  }

  Widget _buildRow(models.Category category, {TextStyle? style}) {
    return RowService.buildRow([
      category.value,
      category.alternatives.toString().replaceAll(RegExp(r'^.|.$'), ''),
    ], style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // Navigate to the page to create new budget entries
        onPressed: _navigateToCategory,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Categorys'),
      ),
      drawer: const AppDrawer(), // Add the drawer here

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: RefreshIndicator(
            onRefresh: _refreshCategorys,
            child: Column(
              children: [
                const SizedBox(height: 30),
                RowService.buildRow(
                  ['Value', 'Alternatives'],
                  Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _categorys.length,
                    itemBuilder: (context, index) {
                      final category = _categorys[index];
                      return Dismissible(
                          key: const ValueKey(Category),
                          background: const ColoredBox(
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                          onDismissed: (_) => _deleteCategory(category),
                          child: ListTile(
                              onTap: () => _navigateToCategory(
                                    category: category,
                                  ),
                              title: _buildRow(category)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
