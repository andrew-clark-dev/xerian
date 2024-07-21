import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutter_settings_screens;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';

//import 'package:xerian/amplify_outputs.dart';
import 'package:xerian/extensions/amplify_extentions.dart';
import 'package:xerian/extensions/model_extensions.dart';

import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';
import 'package:xerian/pages/settings/settings_view.dart';
import 'package:xerian/pages/login/login_screen.dart';
import 'package:xerian/widgets/model_ui_config.dart';

Future<void> main() async {
  try {
    Logger.root.level = Level.ALL;
    await dotenv.load(fileName: "assets/.env");

    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    await flutter_settings_screens.Settings.init();
    runApp(Provider(
      create: (_) => const AmplifyConfig(),
      child: MaterialApp(
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
    ));
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final api = AmplifyAPI(options: APIPluginOptions(modelProvider: ModelProvider.instance));
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, api, storage]);
//    await Amplify.configure(amplifyConfig);
    final String modelUiConfig = await rootBundle.loadString('lib/widgets/model_ui_config.json');
    ModelUiConfiguration.configure(modelUiConfig);
    safePrint('Amplify Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class EncoreShopApp extends StatelessWidget {
  /// Constructs a [EncoreShopApp]
  EncoreShopApp({super.key});

  /// The route configuration.
  late final GoRouter _router = GoRouter(
      initialLocation: Dashboard.classType.viewPath, // start at the dashboard
      routes: <RouteBase>[
        Login.classType.route(page: const LoginScreen()),
        Dashboard.classType.route(page: const DashboardView()),
        Settings.classType.route(page: const SettingsView()),
        Account.classType.route(),
        Account.classType.route(isList: true),
        User.classType.route(),
        User.classType.route(isList: true),
      ],

      // redirect to the login page if the user is not logged in
      redirect: (BuildContext context, GoRouterState state) async {
        // if the user is not logged in, they need to login
        final loggedIn = await Amplify.Auth.isAuthorized;
        final loggingIn = state.path == Login.classType.viewPath;
        if (!loggedIn) return loggingIn ? null : Login.classType.viewPath;

        // if the user is logged in but still on the login page, send them to
        // the dashboard
        if (loggingIn) return Dashboard.classType.viewPath;

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
