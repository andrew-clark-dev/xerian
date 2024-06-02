import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';
import 'package:xerian/pages/routable.dart';

class LoginScreen extends StatelessWidget implements Routable {
  const LoginScreen({super.key});

  @override
  String get path => '/';

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: const DashboardView(),
      ),
    );
  }
}
