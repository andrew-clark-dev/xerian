import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../services/model_extensions.dart';

class ModelListTile {
  final Logger log = Logger("ModelListTile");

  final List<String> fields;

  final BuildContext context;

  ModelListTile(this.fields, this.context);

  ListTile tile(Model model, {bool dismissable = false}) {
    return ListTile(
      title: _buildRow(model, dismissable: dismissable),
      onTap: () => context.push(model.getInstanceType().path(), extra: model),
    );
  }

  Row _buildRow(Model model, {bool dismissable = false}) {
    List<String> values = [];

    for (final field in fields) {
      values.add(model.toMap()[field].toString());
    }

    List<Widget> children = [];
    for (final value in values) {
      children.add(Expanded(
        child: Text(value, textAlign: TextAlign.left),
      ));
    }
    return Row(children: children);
  }
}
