import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'item_view.dart';
import 'pages.dart';

const limit = 20;

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  static String get path => "/${Item.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  ItemListViewState createState() => ItemListViewState();
}

class ItemListViewState extends State<ItemListView> {
  final NumberFormat formatter = NumberFormat("00000000");

  late final Api<Item> _api;

  @override
  void initState() {
    super.initState();
    _api = Api(Item.classType);
    fetchMore();
  }

  List<Item?> items = [];
  PaginatedResult<Item>? page;
  bool loading = true;

  final ScrollController controller = ScrollController();

  Future<void> fetchMore() async {
    loading = true;
    try {
      page = (await _api.fetch(page))!;
      setState(() {
        items += page!.items;
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    } finally {
      loading = false;
    }
  }

  Expanded cell(dynamic value) => Expanded(child: Text(value ?? "", textAlign: TextAlign.left));

  ListTile _tile(Item item) {
    return ListTile(
      title: Row(
        children: [
          cell(formatter.format(item.sku)),
          cell(formatter.format(item.accountNumber ?? 0)),
          cell(item.title),
          cell(item.price.toStringAsFixed(2)),
        ],
      ),
      onTap: () => context.push(ItemView.path, extra: item),
    );
  }

  ListTile _titleTile(List<String> titles) {
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }

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
          itemCount: items.length + ((page?.hasNextResult ?? false) ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              // you can have here your custom widgets for displaying posts or what
              return _tile(items[index]!);
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
          // Navigate to the page to create new items
          onPressed: () => context.push(ItemView.path),
          child: const Icon(Icons.add),
        ),
        appBar: PageBar(Item.schema.pluralName!),
        drawer: const PageDrawer(), // Add the drawer here
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              _titleTile(['SKU', 'Account', 'Title', 'Price']),
              const Divider(),
              Expanded(child: listener())
            ])));
  }
}

class ItemListTile extends ListTile {
  final Model model;
  final Row row;
  final String path;

  const ItemListTile(this.model, this.row, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: row,
      onTap: () => context.push(path, extra: model),
    );
  }
}
