import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xerian/amplify_config_service.dart';

import 'package:go_router/go_router.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/item/item_form.dart';

import 'pages/account/account_list_view.dart';
import 'pages/account/account_view.dart';
import 'pages/dashboard/dashboard_view.dart';
import 'pages/item/item_list_view.dart';
import 'pages/item/item_view.dart';
import 'pages/login/login_screen.dart';
import 'pages/routable.dart';
import 'pages/settings/import_screen.dart';
import 'pages/settings/web_chrome_addresses_settings.dart';
import 'pages/settings/web_chrome_settings.dart';

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
    final auth = AmplifyAuthCognito();
    final api = AmplifyAPI(
        options: APIPluginOptions(modelProvider: ModelProvider.instance));
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, api, storage]);

    final config = await AmplifyConfigService.getConfigFromJson2();
    await Amplify.configure(config);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

GoRoute _route(Routable page) {
  return GoRoute(
    path: page.path,
    builder: (BuildContext context, GoRouterState state) {
      return page;
    },
  );
}

GoRoute _routeExtra(RoutableExtra page) {
  return GoRoute(
    path: page.path,
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra != null) {
        page.extra(state.extra!);
        return AccountView(account: state.extra as Account);
      }
      return page;
    },
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    _route(const LoginScreen()),
    _route(DashboardView()),
    _routeExtra(const AccountView()),
    _route(const AccountListView()),
    _routeExtra(const ItemView()),
    _route(const ItemListView()),
    _route(const ItemForm()),
    GoRoute(
      path: WebChromeSettings.path,
      builder: (BuildContext context, GoRouterState state) {
        return const WebChromeSettings();
      },
    ),
    GoRoute(
      path: WebChromeAddressesScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return const WebChromeAddressesScreen();
      },
    ),
    GoRoute(
      path: ImportScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return const ImportScreen();
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
