import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/route_path.dart';

class TileService {
  final List<String> fields;

  final BuildContext context;

  TileService(this.fields, this.context);

  ListTile tile(Model model) {
    List<String> values = [];

    for (final field in fields) {
      values.add(model.toMap()[field].toString());
    }
    return ListTile(
      title: _buildRow(values),
      onTap: () =>
          context.push(RoutePath.path(model.getInstanceType()), extra: model),
    );
  }

  Row _buildRow(List<String?> values) {
    List<Widget> children = [];
    for (final value in values) {
      children.add(Expanded(
        child: Text(value ?? "", textAlign: TextAlign.left),
      ));
    }
    return Row(children: children);
  }
}
