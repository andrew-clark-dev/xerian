import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encore_shop/models/ModelProvider.dart';
import 'package:encore_shop/pages/login/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'amplifyconfiguration.dart';
import 'pages/account/account_view.dart';
import 'pages/account/account_list_view.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(const EncoreShopApp());
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins(
      [
        AmplifyAuthCognito(),
        AmplifyAPI(
            options: APIPluginOptions(modelProvider: ModelProvider.instance)),
      ],
    );
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AccountView.path,
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra != null) {
          return AccountView(account: state.extra as Account);
        } else {
          return const AccountView();
        }
      },
    ),
    GoRoute(
      path: AccountListView.path,
      builder: (BuildContext context, GoRouterState state) {
        return const AccountListView();
      },
    ),
  ],
);

/// The main app.
class EncoreShopApp extends StatelessWidget {
  /// Constructs a [EncoreShopApp]
  const EncoreShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
