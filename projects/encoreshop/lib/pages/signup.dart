import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:encoreshop/services/cognito.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static String get path => "/signup";

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
    Cognito.signOutCurrentUser();
    return Authenticator(
      initialStep: AuthenticatorStep.signUp,

      // `authenticatorBuilder` is used to customize the UI for one or more steps
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignUpForm(),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          default:
            // Returning not supported for all other actions
            return const Text('Not Supported');
        }
      },
      child: MaterialApp(builder: Authenticator.builder(), home: const Home()),
    );
  }
}
