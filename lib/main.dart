import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xerian/amplify_config_service.dart';
import 'package:go_router/go_router.dart';
import 'package:xerian/models/ModelProvider.dart';

import 'pages/account/account_list_view.dart';
import 'pages/account/account_view.dart';
import 'pages/dashboard/dashboard_view.dart';
import 'pages/item/item_list_view.dart';
import 'pages/item/item_view.dart';
import 'pages/login/login_screen.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(const Xerian());
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
    final amplifyConfig = await AmplifyConfigService.getConfigFromJson();
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
      path: DashboardView.path,
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardView();
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
    GoRoute(
      path: ItemView.path,
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra != null) {
          return ItemView(item: state.extra as Item);
        } else {
          return const ItemView();
        }
      },
    ),
    GoRoute(
      path: ItemListView.path,
      builder: (BuildContext context, GoRouterState state) {
        return const ItemListView();
      },
    ),
  ],
);

class Xerian extends StatelessWidget {
  /// Constructs a [EncoreShopApp]
  const Xerian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
