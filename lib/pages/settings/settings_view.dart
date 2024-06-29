import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:xerian/services/sync_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
                              onTap: () => SyncSevice.syncAccount(),
                            ),
                          ],
                        ),
                      )),
                ]),
              ],
            )));
  }
}
