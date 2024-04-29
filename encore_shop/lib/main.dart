import 'package:encore_shop/src/dashboard/dashboard_page.dart';
import 'package:encore_shop/src/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'src/pages/account/account_view.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const EncoreShopApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPage();
          },
        ),
        GoRoute(
          path: 'account',
          builder: (BuildContext context, GoRouterState state) {
            return const AccountView(
              account: null,
            );
          },
        ),
      ],
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
