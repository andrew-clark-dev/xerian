import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/models/Item.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'item_view.dart';
import 'page_list_view._state.dart';

const limit = 20;

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  static String get path => "/${Item.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  ItemListViewState createState() => ItemListViewState();
}

class ItemListViewState extends PageListViewState<ItemListView> {
  @override
  void initState() {
    api = Api(Item.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    Item item = model as Item;
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

  @override
  ListTile titleTile() {
    final titles = ['SKU', 'Account', 'Title', 'Price'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }
}
