import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:xerian/extensions/model_extensions.dart';
import 'package:xerian/widgets/model_ui_config.dart';

class ModelListTileFactory {
  final Logger log = Logger("ModelListTileFactory");

  late final ModelUiConfig config;

  ModelListTileFactory(ModelType modelType) {
    config = ModelUiConfig.config(modelType);
  }

  ListTile tile(Model model, {TextStyle? style}) {
    return ModelListTile(
        model,
        _row(config.listFieldValues(model), style: style),
        config.modelType.viewPath);
  }

  Row titleRow({TextStyle? style}) =>
      _row(config.listFieldTitleNames, style: style);

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
  final Logger log = Logger("ModelListTile");

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
