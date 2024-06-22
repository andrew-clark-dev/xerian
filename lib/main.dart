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
import 'package:xerian/services/model_extensions.dart';

import 'pages/login/login_screen.dart';

import 'config.dart';

Future<void> main() async {
  try {
    Logger.root.level = Level.ALL;
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(EncoreShopApp());
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

class EncoreShopApp extends StatelessWidget {
  /// Constructs a [EncoreShopApp]
  EncoreShopApp({super.key});

  /// The route configuration.
  late final GoRouter _router = GoRouter(
      initialLocation: Dashboard.classType.path(), // start at the dashboard
      routes: <RouteBase>[
        Config.route(Login.classType, const LoginScreen()),
        Config.route(Dashboard.classType, const DashboardView()),
        Config.listRoute(Account.classType),
        Config.viewRoute(Account.classType),
      ],

      // redirect to the login page if the user is not logged in
      redirect: (BuildContext context, GoRouterState state) async {
        // if the user is not logged in, they need to login
        final loggedIn = await isAuthorized();
        final loggingIn = state.path == Login.classType.path();
        if (!loggedIn) return loggingIn ? null : Login.classType.path();

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggingIn) return '/';

        // no need to redirect at all
        return null;
      });

  Future<bool> isAuthorized() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      safePrint('User is signed in: ${result.isSignedIn}');
      return result.isSignedIn;
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
