import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Handle login logic here
            // For demonstration purposes, let's navigate to the home page
            context.go('/dashboard');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
