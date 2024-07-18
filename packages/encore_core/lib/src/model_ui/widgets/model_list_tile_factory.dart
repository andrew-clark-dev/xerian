import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/model_extensions.dart';

class ModelListTileFactory {
  late final ModelType modelType;

  ModelListTileFactory(this.modelType);

  ListTile tile(Model model, {TextStyle? style}) {
    return ModelListTile(
        model,
        _row(modelType.uiConfig.listFieldValues(model), style: style),
        modelType.viewPath);
  }

  Row titleRow({TextStyle? style}) =>
      _row(modelType.uiConfig.listFieldTitleNames, style: style);

  Row _row(List<String> values, {TextStyle? style}) {
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

class ModelListTile extends ListTile {
  final Model model;
  final Row row;
  final String path;

  ModelListTile(this.model, this.row, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: row,
      onTap: () => context.push(path, extra: model),
    );
  }
}
