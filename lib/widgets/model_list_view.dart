import 'package:logging/logging.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:xerian/widgets/model_list_tile.dart';

import '../pages/routable.dart';
import '../services/api.dart';
import '../services/row_service.dart';

const limit = 20;

class ModelListView extends StatefulWidget implements Routable {
  final Logger log = Logger("ModelListView");

  final ModelType modelType;
  final List<String> fields;

  ModelListView(this.modelType, this.fields, {super.key});

  @override
  // ignore: library_private_types_in_public_api,
  _ModelListViewState createState() => _ModelListViewState();

  @override
  String get path => '/${modelType.modelName().toLowerCase()}list';
}

class _ModelListViewState extends State<ModelListView> {
  late Api api;
  @override
  void initState() {
    super.initState();
    api = Api(widget.modelType);
    _fetchMore();
  }

  List<Model?> models = [];
  PaginatedResult<Model>? page;
  bool loading = true;

  final ScrollController controller = ScrollController();

  Future<void> _fetchMore() async {
    loading = true;
    try {
      page = (await api.fetch(page: page))!;
      setState(() {
        models += page!.items;
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    } finally {
      loading = false;
    }
  }

  NotificationListener listener(TileService tileService) {
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
              return tileService.dismissible(models[index]!);
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
    final tileService = TileService(widget.fields, context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.modelType.modelName().capitalized),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(children: [
              RowService.buildRow(
                widget.fields,
                Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              Expanded(child: listener(tileService))
            ])));
  }
}
