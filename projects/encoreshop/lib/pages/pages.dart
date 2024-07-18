import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home.dart';
import 'account_list_view.dart';

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
        children: <Widget>[_tile(context, "Home", Home.path), _tile(context, "Accounts", AccountListView.path)],
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
  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  void handle(String value) {
    switch (value) {
      case 'Logout':
        signOutCurrentUser();
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(widget.text), actions: [
      PopupMenuButton<String>(
        onSelected: handle,
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: '1',
            child: Text('Profile'),
          ),
          const PopupMenuItem(
            value: '2',
            child: Text('Setting'),
          ),
          const PopupMenuItem(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ],
      )
    ]);
  }
}

abstract class PageViewState<T extends StatefulWidget> extends State<T> {
  late final controllers = <String, TextEditingController>{};

  void initControllers(List<QueryField> fields) {
    for (var f in fields) {
      controllers[f.fieldName] = TextEditingController();
    }
  }

  dynamic getValue(QueryField f) {
    return controllers[f.fieldName]?.text;

    // switch (f.fieldType.fieldType) {
    //   case value:

    //     break;
    //   default:
    // }
  }
}
