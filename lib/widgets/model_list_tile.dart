import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

class TileService {
  final List<String> fields;

  TileService(this.fields);

  ListTile tile(Model model) {
    List<String> values = [];

    for (final field in fields) {
      values.add(model.toMap()[field].toString());
    }
    return ListTile(title: _buildRow(values));
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
