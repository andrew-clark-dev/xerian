import 'package:amplify_core/amplify_core.dart';
import 'package:encoreshop/services/cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'login.dart';

class CascadingMenu extends StatefulWidget {
  const CascadingMenu({super.key});

  @override
  State<CascadingMenu> createState() => _CascadingMenuState();
}

class _CascadingMenuState extends State<CascadingMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  Future<Text> get userText async =>
      Text((await Amplify.Auth.fetchUserAttributes()).firstWhere((a) => a.userAttributeKey == AuthUserAttributeKey.email).value);

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: userText,
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          return MenuAnchor(
            childFocusNode: _buttonFocusNode,
            menuChildren: <Widget>[
              MenuItemButton(
                child: const Text('Revert'),
                onPressed: () {},
              ),
              MenuItemButton(
                child: const Text('Setting'),
                onPressed: () {},
              ),
              MenuItemButton(
                child: const Text('Sign Out'),
                onPressed: () {
                  Cognito.signOutCurrentUser();
                  context.go(Login.path);
                },
              ),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return TextButton.icon(
                label: snapshot.data!,
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.account_circle),
              );
            },
          );
        });
  }
}
