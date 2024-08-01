import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/page_list_view._state.dart';
import 'package:flutter/material.dart';

import '../models/Size.dart';
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'size_view.dart';

const limit = 20;

class SizeListView extends StatefulWidget {
  const SizeListView({super.key});

  static String get path => "/${Size.schema.pluralName!.toLowerCase()}";

  @override
  // ignore: library_private_types_in_public_api,
  SizeListViewState createState() => SizeListViewState();
}

class SizeListViewState extends PageListViewState<SizeListView> {
  @override
  void initState() {
    api = Api(Size.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    Size size = model as Size;
    return ListTile(
      title: Row(
        children: [
          cell(size.name),
          cell(size.active),
          cell(size.alt?.join(', ')),
        ],
      ),
      onTap: () => context.push(SizeView.path, extra: size),
    );
  }

  @override
  ListTile titleTile() {
    final titles = ['Size', 'Active', 'Alternatives'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }
}
