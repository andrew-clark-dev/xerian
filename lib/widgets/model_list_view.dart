import 'package:logging/logging.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:xerian/widgets/model_list_tile.dart';

import '../services/api.dart';
import '../services/model_extensions.dart';
import '../services/row_service.dart';
import 'app_drawer.dart';
import 'package:go_router/go_router.dart';

const limit = 20;

class ModelListView extends StatefulWidget {
  final Logger log = Logger("ModelListView");

  final ModelType modelType;
  final List<String> fields;

  ModelListView(this.modelType, this.fields, {super.key});

  @override
  // ignore: library_private_types_in_public_api,
  _ModelListViewState createState() => _ModelListViewState();
}

class _ModelListViewState extends State<ModelListView> {
  late final Api api;
  late final ModelType modelType;

  @override
  void initState() {
    super.initState();
    modelType = widget.modelType;
    api = Api(modelType);
    _fetchMore();
  }

  List<Model?> models = [];
  PaginatedResult<Model>? page;
  bool loading = true;

  final ScrollController controller = ScrollController();

  Future<void> _fetchMore() async {
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

  NotificationListener listener() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            controller.position.pixels >=
                controller.position.maxScrollExtent - 200 &&
            !loading) {
          // we need to call fetchmore logic here
          if (page!.hasNextResult && !loading) {
            // call here fetchMore
            _fetchMore();
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
              return ModelListTile(models[index]!);
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
          // Navigate to the page to create new models
          onPressed: () => context.push(modelType.path()),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(modelType.schema().pluralName!),
        ),
        drawer: const AppDrawer(), // Add the drawer here
        body: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(children: [
              RowService.buildRow(
                widget.fields,
                Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              Expanded(child: listener())
            ])));
  }
}
