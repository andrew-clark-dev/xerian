import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/pages/page_list_view_state.dart';
import 'package:encoreshop/services/model_extensions.dart';
import 'package:flutter/material.dart';

import '../models/Color.dart';
import '../services/api.dart';

import 'package:go_router/go_router.dart';

import 'color_view.dart';

const limit = 20;

class ColorListView extends StatefulWidget {
  const ColorListView({super.key});

  static String get path => Color.classType.listPath;

  @override
  // ignore: library_private_types_in_public_api,
  ColorListViewState createState() => ColorListViewState();
}

class ColorListViewState extends PageListViewState<ColorListView> {
  @override
  void initState() {
    api = Api(Color.classType);
    super.initState();
  }

  @override
  ListTile tile(Model model) {
    Color color = model as Color;
    return ListTile(
      title: Row(
        children: [
          cell(color.name),
          cell(color.active),
          cell(color.alt?.join(', ')),
        ],
      ),
      onTap: () => context.push(ColorView.path, extra: color),
    );
  }

  @override
  ListTile get titleTile {
    final titles = ['Color', 'Active', 'Alternatives'];
    return ListTile(
      title: Row(children: titles.map((t) => cell(t)).toList()),
    );
  }

  @override
  ModelType<Model> get modelType => Color.classType;
}
