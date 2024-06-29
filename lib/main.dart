import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:xerian/amplify_outputs.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';
import 'package:xerian/pages/settings/settings_view.dart';
import 'package:xerian/services/model_extensions.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as flutter_settings_screens;
import 'pages/login/login_screen.dart';

import 'model_config.dart';

Future<void> main() async {
  try {
    Logger.root.level = Level.ALL;
    await dotenv.load(fileName: "assets/.env");

    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    await flutter_settings_screens.Settings.init();
    runApp(
      MaterialApp(
        title: 'Encore Shop',
        theme: ThemeData(
          useMaterial3: true,

          // // Define the default brightness and colors.
          // colorScheme: ColorScheme.fromSeed(
          //   seedColor: Colors.purple,
          //   // ···
          //   brightness: Brightness.dark,
          // ),

          // // Define the default `TextTheme`. Use this to specify the default
          // // text styling for headlines, titles, bodies of text, and more.
          // textTheme: TextTheme(
          //   displayLarge: const TextStyle(
          //     fontSize: 72,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   // ···
          //   titleLarge: GoogleFonts.oswald(
          //     fontSize: 30,
          //     fontStyle: FontStyle.italic,
          //   ),
          //   bodyMedium: GoogleFonts.merriweather(),
          //   displaySmall: GoogleFonts.pacifico(),
          // ).apply(
          //   bodyColor: Colors.pink,
          //   displayColor: Colors.pink,
          // ),
        ),
        home: EncoreShopApp(),
      ),
    );
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

//    final config = await AmplifyConfigService.getConfigFromJson();
//    final AmplifyOutputs amplifyOutput = AmplifyOutputs.fromJson(jsonDecode(amplifyConfig));

    var json = jsonDecode(amplifyConfig);

    Map<String, dynamic> restApiConfig = {
      'sync-account': {
        'aws_region': 'eu-central-1',
        'url':
            'https://gd8etxduk1.execute-api.eu-central-1.amazonaws.com/dev/sync-account',
        'authorization_type': 'AMAZON_COGNITO_USER_POOLS'
      }
    };
    json['rest_api'] = restApiConfig;

    await Amplify.configure(jsonEncode(json));

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
        ModelConfig(Login.classType).route(const LoginScreen()),
        ModelConfig(Dashboard.classType).route(const DashboardView()),
        ModelConfig(Settings.classType).route(const SettingsView()),
        ModelConfig(Account.classType).listRoute(),
        ModelConfig(Account.classType).viewRoute(),
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
