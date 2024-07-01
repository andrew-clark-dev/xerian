import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:xerian/widgets/model_app_bar.dart';

/// Displaysthe application dashboard.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ModelAppBar(Dashboard.classType),
        drawer: const AppDrawer(), // Add the drawer here

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
