import 'package:xerian/pages/account/account_list_view.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:xerian/pages/item/item_form.dart';

import '../pages/routable.dart';
import '../pages/settings/web_chrome_settings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  ListTile _listTile(BuildContext context, Routable page, String title) {
    return ListTile(
        title: Text(title),
        onTap: () {
          context.go(page.path);
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
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              context.go('/dashboard');
            },
          ),
          ListTile(
            title: const Text('Items'),
            onTap: () {
              context.go('/items');
            },
          ),
          ListTile(
            title: const Text('Sales'),
            onTap: () {
              context.go('/sales');
            },
          ),
          ListTile(
            title: const Text('Accounts'),
            onTap: () {
              context.go(AccountListView.path);
            },
          ),
          _listTile(context, const ItemForm(), 'Add item'),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              context.push(WebChromeSettings.path);
            },
          ),
          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }
}
