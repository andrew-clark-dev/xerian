import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encoreitem/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:encore_core/extentions.dart';
import 'amplify_outputs.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureAmplify();
  runApp(EncoreItem());
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();

    await Amplify.addPlugins([auth]);
    await Amplify.configure(amplifyConfig);
    safePrint('Amplify Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class EncoreItem extends StatelessWidget {
  EncoreItem({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const Login(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      // if the user is not logged in, they need to login
      final loggedIn = await Amplify.Auth.isAuthorized;
      final loggingIn = state.path == "/login";
      if (!loggedIn) return loggingIn ? null : "/login";

      // if the user is logged in but still on the login page, send them to
      // the home
      if (loggingIn) return "/";

      // no need to redirect at all
      return null;
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Encore Item',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
