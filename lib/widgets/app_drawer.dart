import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/extensions/model_extensions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  ListTile _listTile(BuildContext context, ModelType modelType) {
    return ListTile(
        title: Text(modelType.schema.pluralName!),
        onTap: () {
          context.go(modelType.listPath);
        });
  }

  ListTile _viewTile(BuildContext context, ModelType modelType) {
    return ListTile(
        title: Text(modelType.schema.name),
        onTap: () {
          context.go(modelType.viewPath);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _viewTile(context, Dashboard.classType),
          _listTile(context, Account.classType),
          // _listTile(context, const AdminSettings().path, 'Administration'),
        ],
      ),
    );
  }
}
