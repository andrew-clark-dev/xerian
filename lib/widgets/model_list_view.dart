import 'package:logging/logging.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/widgets/model_list_tile.dart';

import '../pages/routable.dart';
import '../services/api.dart';
import '../services/route_path.dart';
import '../services/row_service.dart';
import 'app_drawer.dart';
import 'package:go_router/go_router.dart';

const limit = 20;

class ModelListView extends StatefulWidget implements Routable {
  final Logger log = Logger("ModelListView");

  final ModelType modelType;
  final List<String> fields;

  final DropDownFilter? filter;

  ModelListView(this.modelType, this.fields, {super.key, this.filter});

  @override
  // ignore: library_private_types_in_public_api,
  _ModelListViewState createState() => _ModelListViewState();

  @override
  String get path => '/${modelType.modelName().toLowerCase()}list';
}

class _ModelListViewState extends State<ModelListView> {
  late Api api;
  late DropDownFilter? filter;
  late DropdownMenu? menu;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
    menu = filter?.menu();
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
      final queryPredicate = Group.TYPE.eq(GroupType.color);

      final query = filter == null
          ? null
          : const QueryPredicateOperation(
              "type", EqualQueryOperator<String>(""));
      // EqualQueryOperator<Model>(menu!.controller!.value as Model));
      page = (await api.fetch(page, query: queryPredicate))!;
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
        floatingActionButton: FloatingActionButton(
          // Navigate to the page to create new budget entries
          onPressed: () => context.push(RoutePath.path(widget.modelType)),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(widget.modelType.modelName().capitalized),
        ),
        drawer: const AppDrawer(), // Add the drawer here
        body: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(children: [
              if (filter != null) filter!.menu(),
              RowService.buildRow(
                widget.fields,
                Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              Expanded(child: listener(tileService))
            ])));
  }
}

class DropDownFilter<T extends Enum> {
  final TextEditingController controller = TextEditingController();

  final List<T> values;

  DropDownFilter(this.values);

  DropdownMenu menu() {
    return DropdownMenu(
        controller: controller,
        dropdownMenuEntries: (this
            .values
            .map((e) => DropdownMenuEntry<T>(value: e, label: (e as Enum).name))
            .toList()));
  }
}
