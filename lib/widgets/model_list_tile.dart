import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:xerian/model_config.dart';

import '../extensions/model_extensions.dart';

class ModelListTile extends ListTile {
  final Logger log = Logger("ModelListTile");

  final Model model;

  ModelListTile(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    final fields = ModelConfig(model.getInstanceType()).values(model);
    return ListTile(
      title: buildRow(fields),
      onTap: () => context.push(model.getInstanceType().path(), extra: model),
    );
  }

  static Row buildRow(List values, {TextStyle? style}) {
    List<Widget> children = [];
    for (final value in values) {
      children.add(Expanded(
        child: Text(
          value,
          textAlign: TextAlign.left,
          style: style,
        ),
      ));
    }
    return Row(children: children);
  }
}
