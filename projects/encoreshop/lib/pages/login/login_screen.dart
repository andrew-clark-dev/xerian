import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:xerian/pages/dashboard/dashboard_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return Scaffold(
              appBar: AppBar(title: const Text('My App')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // flutter logo
                    const Center(child: FlutterLogo(size: 100)),
                    // prebuilt sign in form from amplify_authenticator package
                    SignInForm(),
                  ],
                ),
              ),
            );
          default:
            return null;
        }
      },
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: const DashboardView(),
      ),
    );
  }
}
