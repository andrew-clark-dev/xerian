import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xerian/models/Settings.dart';
import 'package:xerian/services/model_extensions.dart';

class ModelAppBar extends AppBar {
  final ModelType modelType;
  final bool plural;
  final Crud operation;

  ModelAppBar(this.modelType,
      {super.key, this.plural = false, this.operation = Crud.none});

  @override
  State<ModelAppBar> createState() => _ModelAppBarState();
}

class _ModelAppBarState extends State<ModelAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.modelType.schema().name),
      actions: [
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push(Settings.classType.path());
            }),
      ],
    );
  }
}

enum Crud {
  create(name: "Create"),
  read(name: ""),
  update(name: "Update"),
  delete(name: "Delete"),
  none(name: "");

  final String name;
  const Crud({required this.name});

  String title(ModelType modelType, {bool plural = false}) {
    final modelName =
        plural ? modelType.schema().pluralName : modelType.schema().name;
    return '$name $modelName';
  }
}
