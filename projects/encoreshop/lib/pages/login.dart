import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static String get path => "/login";

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(builder: Authenticator.builder(), home: const Home()),
    );
  }
}
