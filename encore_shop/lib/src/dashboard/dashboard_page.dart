import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the login screen
            context.go('/');
          },
          child: const Text('Go to Login Page'),
        ),
      ),
    );
  }
}
