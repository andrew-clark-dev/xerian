import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/page_list_view._state.dart';
import 'package:flutter/material.dart';

import '../models/Category.dart' as m;
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'category_view.dart';

const limit = 20;

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  static String get path => "/${m.Category.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  CategoryListViewState createState() => CategoryListViewState();
}

class CategoryListViewState extends PageListViewState<CategoryListView> {
  @override
  void initState() {
    api = Api(m.Category.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    m.Category brand = model as m.Category;
    return ListTile(
      title: Row(
        children: [
          cell(brand.name),
          cell(brand.active),
          cell(brand.alt?.join(', ')),
        ],
      ),
      onTap: () => context.push(CategoryView.path, extra: brand),
    );
  }

  @override
  ListTile titleTile() {
    final titles = ['Category', 'Active', 'Alternatives'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }
}
