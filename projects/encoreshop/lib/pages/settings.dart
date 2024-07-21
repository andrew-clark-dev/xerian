import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  static String get path => "/settings";

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                            // SimpleSettingsTile(
                            //   title: 'Custom Settings',
                            //   subtitle: 'Tap to execute custom callback',
                            //   onTap: () => request(),
                            // ),
                            const SettingsContainer(children: [Text("Some text ")]),
                          ],
                        ),
                      )),
                ]),
              ],
            )));
  }
}
