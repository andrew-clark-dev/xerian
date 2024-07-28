import 'package:amplify_core/amplify_core.dart';
import 'package:encore_core/extentions.dart';
import 'package:encoreshop/models/Account.dart';
import 'package:encoreshop/pages/user_settings.dart';
import 'package:encoreshop/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/account_list_view.dart';
import 'pages/account_view.dart';
import 'pages/home.dart';
import 'pages/login.dart';

// This is brilliant, should be in a util package
T? cast<T>(dynamic x) => x is T ? x : null;

// List of admin only routes
final List<String> adminRoutes = [SignUp.path];

final router = GoRouter(
  initialLocation: Home.path,
  routes: [
    GoRoute(
      path: Home.path,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: Login.path,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: SignUp.path,
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: UserSettings.path,
      builder: (context, state) => const UserSettings(),
    ),
    GoRoute(
      path: AccountListView.path,
      builder: (context, state) => const AccountListView(),
    ),
    GoRoute(
      path: AccountView.path,
      builder: (context, state) => AccountView(account: cast<Account>(state.extra)),
    )
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    // if the user is not logged in, they need to login
    final loggedIn = await Amplify.Auth.isAuthorized;
    final loggingIn = state.path == Login.path;
    if (!loggedIn) return loggingIn ? null : Login.path;

    final isAdmin = await Amplify.Auth.hasAdminPrivilages;
    // Check if the user is trying to access a protected route
    final bool isAccessingProtectedRoute = adminRoutes.contains(state.fullPath);
    if (isAccessingProtectedRoute && !isAdmin) return "/unauthorized";

    // if the user is logged in but still on the login page, send them to
    // the home
    if (loggingIn) return Home.path;

    // no need to redirect at all
    return null;
  },
);
