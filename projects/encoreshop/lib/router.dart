import 'package:amplify_core/amplify_core.dart';
import 'package:encore_core/extentions.dart';
import 'package:encoreshop/models/Account.dart';
import 'package:encoreshop/models/Brand.dart';
import 'package:encoreshop/models/Item.dart';
import 'package:encoreshop/models/Color.dart' as c;
import 'package:encoreshop/models/Size.dart' as s;
import 'package:encoreshop/pages/user_settings.dart';
import 'package:encoreshop/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/account_list_view.dart';
import 'pages/account_view.dart';
import 'pages/brand_list_view.dart';
import 'pages/brand_view.dart';
import 'pages/category_list_view.dart';
import 'pages/category_view.dart';
import 'pages/color_list_view.dart';
import 'pages/color_view.dart';
import 'pages/home.dart';
import 'pages/item_list_view.dart';
import 'pages/item_view.dart';
import 'pages/login.dart';
import '../models/Category.dart' as m;
import 'pages/size_list_view.dart';
import 'pages/size_view.dart';

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
    ),
    GoRoute(
      path: ItemListView.path,
      builder: (context, state) => const ItemListView(),
    ),
    GoRoute(
      path: ItemView.path,
      builder: (context, state) => ItemView(item: cast<Item>(state.extra)),
    ),
    GoRoute(
      path: BrandListView.path,
      builder: (context, state) => const BrandListView(),
    ),
    GoRoute(
      path: BrandView.path,
      builder: (context, state) => BrandView(brand: cast<Brand>(state.extra)),
    ),
    GoRoute(
      path: CategoryListView.path,
      builder: (context, state) => const CategoryListView(),
    ),
    GoRoute(
      path: CategoryView.path,
      builder: (context, state) => CategoryView(brand: cast<m.Category>(state.extra)),
    ),
    GoRoute(
      path: ColorListView.path,
      builder: (context, state) => const ColorListView(),
    ),
    GoRoute(
      path: ColorView.path,
      builder: (context, state) => ColorView(color: cast<c.Color>(state.extra)),
    ),
    GoRoute(
      path: SizeListView.path,
      builder: (context, state) => const SizeListView(),
    ),
    GoRoute(
      path: SizeView.path,
      builder: (context, state) => SizeView(size: cast<s.Size>(state.extra)),
    ),
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
