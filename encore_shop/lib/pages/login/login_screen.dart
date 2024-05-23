import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:encore_shop/pages/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
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
