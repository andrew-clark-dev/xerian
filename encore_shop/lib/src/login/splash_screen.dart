import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here (e.g., logo, animation, etc.)
            CircularProgressIndicator(), // Example: Loading spinner
            SizedBox(height: 16),
            Text('Loading...'), // Example: Text message
          ],
        ),
      ),
    );
  }
}
