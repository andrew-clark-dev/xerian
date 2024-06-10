import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../services/route_path.dart';

class TileService {
  final Logger log = Logger("TileService");

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
    children.add(const Expanded(
      child: Icon(Icons.delete),
    ));
    return Row(children: children);
  }

  Future<void> _deleteModel(Model model) async {
    final request = ModelMutations.delete<Model>(model);
    final response = await Amplify.API.mutate(request: request).response;
    log.info(
        'Delete ${model.getInstanceType().modelName()} response: $response');
  }

  Dismissible dismissible(Model model) {
    return Dismissible(
        key: const ValueKey(Model),
        background: const ColoredBox(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        onDismissed: (_) => _deleteModel(model),
        child: tile(model));
  }
}
