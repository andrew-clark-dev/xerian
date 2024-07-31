import 'package:encoreshop/pages/category_list_view.dart';
import 'package:encoreshop/pages/item_list_view.dart';
import 'package:encoreshop/services/cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'brand_list_view.dart';
import 'home.dart';
import 'account_list_view.dart';
import 'user_settings.dart';

class PageDrawer extends StatelessWidget {
  const PageDrawer({super.key});

  ListTile _tile(BuildContext context, String title, String path) {
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
          _tile(context, "Home", Home.path),
          _tile(context, "Accounts", AccountListView.path),
          _tile(context, "Items", ItemListView.path),
          _tile(context, "Brands", BrandListView.path),
          _tile(context, "Categories", CategoryListView.path),
        ],
      ),
    );
  }
}

class PageBar extends AppBar {
  late final String text;

  PageBar(this.text, {super.key});

  @override
  State<PageBar> createState() => _PageBarState();
}

class _PageBarState extends State<PageBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: Cognito.userText,
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          return AppBar(title: Text(widget.text), actions: [
            TextButton.icon(
              label: snapshot.data ?? const Text("None"),
              onPressed: () {
                context.push(UserSettings.path);
              },
              icon: const Icon(Icons.account_circle),
            ),
          ]);
        });
  }
}
