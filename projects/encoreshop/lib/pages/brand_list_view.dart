import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/page_list_view._state.dart';
import 'package:flutter/material.dart';

import '../models/Brand.dart';
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'brand_view.dart';

const limit = 20;

class BrandListView extends StatefulWidget {
  const BrandListView({super.key});

  static String get path => "/${Brand.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  BrandListViewState createState() => BrandListViewState();
}

class BrandListViewState extends PageListViewState<BrandListView> {
  @override
  void initState() {
    api = Api(Brand.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    Brand brand = model as Brand;
    return ListTile(
      title: Row(
        children: [
          cell(brand.name),
          cell(brand.active),
          cell(brand.alt?.join(', ')),
        ],
      ),
      onTap: () => context.push(BrandView.path, extra: brand),
    );
  }

  @override
  ListTile titleTile() {
    final titles = ['Brand', 'Active', 'Alternatives'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }
}
