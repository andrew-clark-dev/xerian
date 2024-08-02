import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/services/model_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'pages.dart';

const limit = 20;

abstract class PageListViewState<T extends StatefulWidget> extends State<T> {
  final NumberFormat formatter = NumberFormat("00000000");

  late final Api api;

  @override
  void initState() {
    super.initState();
    fetchMore();
  }

  List<Model?> models = [];
  PaginatedResult<Model>? page;
  bool loading = true;

  final ScrollController controller = ScrollController();

  Future<void> fetchMore() async {
    loading = true;
    try {
      page = (await api.fetch(page))!;
      setState(() {
        models += page!.items;
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    } finally {
      loading = false;
    }
  }

  Expanded cell(dynamic value) => Expanded(child: Text(value ?? "", textAlign: TextAlign.left));

  ListTile tile(Model model);

  ListTile get titleTile;

  ModelType get modelType;

  NotificationListener listener() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            controller.position.pixels >= controller.position.maxScrollExtent - 200 &&
            !loading) {
          // we need to call fetchmore logic here
          if (page!.hasNextResult && !loading) {
            // call here fetchMore
            fetchMore();
          }
        }
        return true;
      },
      child: ListView.builder(
          // attach the scroll controller to this List
          controller: controller,
          // we can pragmatically increase posts length by 1 to show a spinner for loading more
          itemCount: models.length + ((page?.hasNextResult ?? false) ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < models.length) {
              // you can have here your custom widgets for displaying posts or what
              return tile(models[index]!);
            } else {
              return loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          // Navigate to the page to create new accounts
          onPressed: () => context.push(modelType.viewPath),
          child: const Icon(Icons.add),
        ),
        appBar: PageBar(modelType.schema.pluralName!),
        drawer: const PageDrawer(), // Add the drawer here
        body: Padding(
            padding: const EdgeInsets.all(25), child: Column(children: [titleTile, const Divider(), Expanded(child: listener())])));
  }
}
