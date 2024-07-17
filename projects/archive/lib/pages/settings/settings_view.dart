import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:xerian/models/ModelProvider.dart';

const graphQLDocument = '''
mutation PublishRequest (\$source: String!, \$payload: String!) {
  publishRequest(source: \$source, payload: \$payload)
}
''';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<void> request() async {
    safePrint(Account.classType.modelName());

    final clientRequest = GraphQLRequest<String>(
      document: graphQLDocument,
      variables: <String, String>{
        "source": "frontend.account.sync.request",
        "payload": "a payload"
      },
    );

    final response = await Amplify.API.mutate(request: clientRequest).response;

    safePrint(response);
  }

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: SettingsScreen(
              title: 'Application Settings',
              children: [
                SettingsGroup(title: 'Adminstration', children: <Widget>[
                  SimpleSettingsTile(
                      title: 'Synchronize with Consigncloud',
                      subtitle: 'General App Settings',
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: SettingsScreen(
                          title: 'Synchronize with Consigncloud',
                          children: <Widget>[
                            const TextInputSettingsTile(
                              title: 'api key',
                              settingKey: 'cc-sync-api-key',
                              obscureText: true,
                              borderColor: Colors.blueAccent,
                              errorColor: Colors.deepOrangeAccent,
                            ),
                            TextInputSettingsTile(
                              title: 'limit',
                              settingKey: 'cc-sync-limit',
                              borderColor: Colors.blueAccent,
                              errorColor: Colors.deepOrangeAccent,
                              initialValue: '0',
                              validator: (String? limit) {
                                if (int.tryParse(limit ?? '') != null) {
                                  return null;
                                }
                                return "Must be an integer";
                              },
                            ),
                            SimpleSettingsTile(
                              title: 'Custom Settings',
                              subtitle: 'Tap to execute custom callback',
                              onTap: () => request(),
                            ),
                            const SettingsContainer(
                                children: [Text("Some text ")]),
                          ],
                        ),
                      )),
                ]),
              ],
            )));
  }
}
