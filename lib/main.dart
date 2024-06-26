import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xerian/amplify_config_service.dart';
import 'package:logging/logging.dart';

import 'package:go_router/go_router.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/admin/admin_settings.dart';
import 'package:xerian/pages/group/group_list_view.dart';
import 'package:xerian/pages/group/group_view.dart';
import 'package:xerian/pages/item/item_form.dart';

import 'pages/account/account_list_view.dart';
import 'pages/account/account_view.dart';
import 'pages/dashboard/dashboard_view.dart';
import 'pages/item/item_list_view.dart';
import 'pages/item/item_view.dart';
import 'pages/login/login_screen.dart';
import 'pages/routable.dart';

Future<void> main() async {
  try {
    Logger.root.level = Level.ALL;
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

GoRoute _routeExtra(RoutableExtra prototype) {
  return GoRoute(
    path: prototype.path,
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra != null) {
        return prototype.extra(state.extra!);
      }
      return prototype;
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
    _routeExtra(const GroupView()),
    _route(GroupListView()),
    _route(const AdminSettings()),
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
