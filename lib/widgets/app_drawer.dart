import 'package:xerian/pages/account/account_list_view.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:xerian/pages/admin/admin_settings.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';
import 'package:xerian/pages/item/item_form.dart';
import 'package:xerian/pages/item/item_list_view.dart';

import '../models/Group.dart';
import '../services/route_path.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  ListTile _listTile(BuildContext context, String path, String title) {
    return ListTile(
        title: Text(title),
        onTap: () {
          context.go(path);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          _listTile(context, DashboardView().path, 'Dashboard'),
          _listTile(context, const ItemListView().path, 'Items'),
          ListTile(
            title: const Text('Sales'),
            onTap: () {
              context.go('/sales');
            },
          ),
          _listTile(context, const AccountListView().path, 'Accounts'),
          _listTile(context, RoutePath.listPath(Group.classType), 'Categories'),
          _listTile(context, const ItemForm().path, 'Add item'),
          _listTile(context, const AdminSettings().path, 'Administration'),
        ],
      ),
    );
  }
}
