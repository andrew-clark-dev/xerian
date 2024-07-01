import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:xerian/models/ModelProvider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<void> request() async {
    safePrint(ServerEventType.modelsync.name.toUpperCase());
    safePrint(Account.classType.modelName());

    final serverEventRequest = GraphQLRequest<String>(
      document: graphQLDocument,
      variables: <String, String>{
        "source": "amplify.server-events",
        "detailType": "ServerEvent",
        "payload": "{'name: 'andrew'}",
      },
    );

    final response =
        await Amplify.API.query(request: serverEventRequest).response;

    safePrint(response);
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
                          ],
                        ),
                      )),
                ]),
              ],
            )));
  }
}

class ServerEventResponse {
  final ServerEvent serverEvent;

  ServerEventResponse({required this.serverEvent});

  factory ServerEventResponse.fromJson(Map<String, dynamic> json) {
    return ServerEventResponse(
      serverEvent: ServerEvent.fromJson(json['serverEvent']),
    );
  }
}

const graphQLDocument = '''
mutation PublishClientRequestToEventBridge(
  \$source: String!
  \$detailType: String!
  \$payload: String!
) {
  publishClientRequestToEventBridge(
    source: \$source
    detailType: \$detailType
    payload: \$payload
  ) {
    source
    detailType
    payload
  }
}
''';
