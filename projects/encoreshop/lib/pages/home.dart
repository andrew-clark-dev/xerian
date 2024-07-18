import 'package:flutter/material.dart';

import 'pages.dart';

/// Displaysthe application dashboard.
class Home extends StatelessWidget {
  const Home({super.key});

  static String get path => "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageBar("Home"),
        drawer: const PageDrawer(), // Add the drawer here
        body: const Center(
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
