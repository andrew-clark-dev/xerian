import 'package:flutter/material.dart';

/// Displaysthe application dashboard.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(children: [
        TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ))
      ]),
    ));
  }
}
