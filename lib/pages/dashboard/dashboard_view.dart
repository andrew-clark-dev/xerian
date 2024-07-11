import 'package:amplify_core/amplify_core.dart';
import 'package:xerian/extensions/amplify_extentions.dart';
import 'package:xerian/models/ModelProvider.dart';
import 'package:xerian/widgets/model_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:xerian/widgets/model_app_bar.dart';

/// Displaysthe application dashboard.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
      }
      final currentUser = await Amplify.Auth.getCurrentUser();
      safePrint(currentUser.toJson());
      await Amplify.Auth.awsClientCredentials();
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchCurrentUserAttributes();
    return Scaffold(
        appBar: ModelAppBar(Dashboard.classType),
        drawer: const ModelAppDrawer(), // Add the drawer here

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
