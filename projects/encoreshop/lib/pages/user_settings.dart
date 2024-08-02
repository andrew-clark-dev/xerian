import 'package:encoreshop/pages/signup.dart';
import 'package:encoreshop/services/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:go_router/go_router.dart';

import '../services/upload_file.dart';
import 'login.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  static String get path => "/settings";

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: SettingsScreen(
              title: 'Application Settings',
              children: [
                SettingsGroup(title: 'User', children: <Widget>[
                  SimpleSettingsTile(
                      title: 'Logout current User',
                      onTap: () async {
                        await Cognito.signOutCurrentUser();
                        if (context.mounted) context.go(Login.path);
                      }),
                  SimpleSettingsTile(
                      title: 'Initiate Sign Up', //
                      onTap: () => context.go(SignUp.path)), //
                ]),
                SettingsGroup(title: 'Adminstration', children: <Widget>[
                  SimpleSettingsTile(
                    title: 'More Settings',
                    subtitle: 'General App Settings',
                    child: SettingsScreen(
                      title: 'App Settings',
                      children: <Widget>[
                        SimpleSettingsTile(
                            leading: const Icon(Icons.file_upload),
                            title: 'Upload File',
                            onTap: () async {
                              await UploadFile().uploadDataImportFile();
                            }),
                        CheckboxSettingsTile(
                          leading: const Icon(Icons.adb),
                          settingKey: 'key-is-developer',
                          title: 'Developer Mode',
                          onChange: (bool value) {
                            debugPrint('Developer Mode ${value ? 'on' : 'off'}');
                          },
                        ),
                        SwitchSettingsTile(
                          leading: const Icon(Icons.usb),
                          settingKey: 'key-is-usb-debugging',
                          title: 'USB Debugging',
                          onChange: (value) {
                            debugPrint('USB Debugging: $value');
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            )));
  }
}
