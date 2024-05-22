import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encore_shop/models/Item.dart';
import 'package:encore_shop/services/row_service.dart';
import 'package:encore_shop/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ItemListView extends StatefulWidget {
  static const path = '/items';
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  List<Item> _items = <Item>[];

  final NumberFormat formatter = NumberFormat("00000000");

  // Define variables for managing list data and scrolling
  final ScrollController _scrollController = ScrollController();
  // Method to add more data when scrolling reaches the end
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _refreshItems();
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
    // Attach listener to scroll controller
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _refreshItems() async {
    try {
      final request = ModelQueries.list(Item.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        final items = response.data?.items;
        _items = items!.whereType<Item>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  Future<void> _deleteItem(Item item) async {
    final request = ModelMutations.delete<Item>(item);
    final response = await Amplify.API.mutate(request: request).response;
    safePrint('Delete response: $response');
    await _refreshItems();
  }

  Future<void> _navigateToItem({Item? item}) async {
    context.push('/item', extra: item);
    // Refresh the entries when returning from Items detail screen.
    await _refreshItems();
  }

  Widget _buildRow(Item item, {TextStyle? style}) {
    return RowService.buildRow([
      formatter.format(item.sku),
      item.description,
    ], style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // Navigate to the page to create new budget entries
        onPressed: _navigateToItem,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Items'),
      ),
      drawer: const AppDrawer(), // Add the drawer here

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: RefreshIndicator(
            onRefresh: _refreshItems,
            child: Column(
              children: [
                const SizedBox(height: 30),
                RowService.buildRow(
                  [
                    'SKU',
                    'Description',
                  ],
                  Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Dismissible(
                          key: const ValueKey(Item),
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
                          onDismissed: (_) => _deleteItem(item),
                          child: ListTile(
                              onTap: () => _navigateToItem(
                                    item: item,
                                  ),
                              title: _buildRow(item)));
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
