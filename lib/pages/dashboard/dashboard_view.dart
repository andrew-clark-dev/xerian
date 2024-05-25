import 'package:xerian/services/counter_service.dart';
import 'package:xerian/widgets/app_drawer.dart';
import 'package:xerian/widgets/single_file_picker.dart';
import 'package:flutter/material.dart';

/// Displaysthe application dashboard.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const path = '/dashboard';

  @override
  Widget build(BuildContext context) {
    CounterService.initialize();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       // Navigate to the settings page. If the user leaves and returns
        //       // to the app after it has been killed while running in the
        //       // background, the navigation stack is restored.
        //       Navigator.restorablePushNamed(context, SettingsView.routeName);
        //     },
        //   ),
        // ],
      ),

      drawer: const AppDrawer(), // Add the drawer here

      body: const Center(
        child: SingleFilePicker(),
      ),
    );
  }
}
