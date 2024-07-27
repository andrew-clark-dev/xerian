import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static String get path => "/login";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // `authenticatorBuilder` is used to customize the UI for one or more steps
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          default:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: SignUpForm(),
            );
        }
      },
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: const Scaffold(
          body: Center(
            child: Text('You are logged in!'),
          ),
        ),
      ),
    );
  }
}
