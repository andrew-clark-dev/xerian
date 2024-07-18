import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Authenticator(
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
