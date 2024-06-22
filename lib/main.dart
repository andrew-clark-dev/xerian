import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:xerian/amplify_config_service.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';

import 'pages/login/login_screen.dart';

import 'config.dart';

Future<void> main() async {
  try {
    Logger.root.level = Level.ALL;
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(const EncoreShopApp());
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

    final config = await AmplifyConfigService.getConfigFromJson();
    await Amplify.configure(config);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const LoginScreen();
    },
  ),
  Config.route(Dashboard.classType, const DashboardView()),
  Config.listRoute(Account.classType),
  Config.viewRoute(Account.classType),
]);

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
