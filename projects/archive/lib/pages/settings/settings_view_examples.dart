import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsViewExamples extends StatefulWidget {
  const SettingsViewExamples({super.key});

  @override
  State<SettingsViewExamples> createState() => _SettingsViewExamplesState();
}

class _SettingsViewExamplesState extends State<SettingsViewExamples> {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'Application Settings',
      children: [
        SettingsGroup(
          title: 'Single Choice Settings',
          children: <Widget>[
            SwitchSettingsTile(
              settingKey: 'key-wifi',
              title: 'Wi-Fi',
              subtitle: 'Wi-Fi allows interacting with the local network '
                  'or internet via connecting to a W-Fi router',
              enabledLabel: 'Enabled',
              disabledLabel: 'Disabled',
              leading: const Icon(Icons.wifi),
              onChange: (value) {
                debugPrint('key-wifi: $value');
              },
            ),
            CheckboxSettingsTile(
              settingKey: 'key-blue-tooth',
              title: 'Bluetooth',
              subtitle: 'Bluetooth allows interacting with the '
                  'near by bluetooth enabled devices',
              enabledLabel: 'Enabled',
              disabledLabel: 'Disabled',
              leading: const Icon(Icons.bluetooth),
              onChange: (value) {
                debugPrint('key-blue-tooth: $value');
              },
            ),
            SwitchSettingsTile(
              leading: const Icon(Icons.developer_mode),
              settingKey: 'key-switch-dev-mode',
              title: 'Developer Settings',
              onChange: (value) {
                debugPrint('key-switch-dev-mod: $value');
              },
              childrenIfEnabled: <Widget>[
                CheckboxSettingsTile(
                  leading: const Icon(Icons.adb),
                  settingKey: 'key-is-developer',
                  title: 'Developer Mode',
                  defaultValue: true,
                  onChange: (value) {
                    debugPrint('key-is-developer: $value');
                  },
                ),
                SwitchSettingsTile(
                  leading: const Icon(Icons.usb),
                  settingKey: 'key-is-usb-debugging',
                  title: 'USB Debugging',
                  onChange: (value) {
                    debugPrint('key-is-usb-debugging: $value');
                  },
                ),
                const SimpleSettingsTile(
                  title: 'Root Settings',
                  subtitle: 'These setting is not accessible',
                  enabled: false,
                ),
                SimpleSettingsTile(
                  title: 'Custom Settings',
                  subtitle: 'Tap to execute custom callback',
                  onTap: () => debugPrint('Custom action'),
                ),
              ],
            ),
            SimpleSettingsTile(
              title: 'More Settings',
              subtitle: 'General App Settings',
              child: SettingsScreen(
                title: 'App Settings',
                children: <Widget>[
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
            TextInputSettingsTile(
              title: 'User Name',
              settingKey: 'key-user-name',
              initialValue: 'admin',
              validator: (String? username) {
                if (username != null && username.length > 3) {
                  return null;
                }
                return "User Name can't be smaller than 4 letters";
              },
              borderColor: Colors.blueAccent,
              errorColor: Colors.deepOrangeAccent,
            ),
            TextInputSettingsTile(
              title: 'password',
              settingKey: 'key-user-password',
              obscureText: true,
              validator: (String? password) {
                if (password != null && password.length > 6) {
                  return null;
                }
                return "Password can't be smaller than 7 letters";
              },
              borderColor: Colors.blueAccent,
              errorColor: Colors.deepOrangeAccent,
            ),
            ModalSettingsTile(
              title: 'Quick setting dialog',
              subtitle: 'Settings on a dialog',
              children: <Widget>[
                CheckboxSettingsTile(
                  settingKey: 'key-day-light-savings',
                  title: 'Daylight Time Saving',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: const Icon(Icons.timelapse),
                  onChange: (value) {
                    debugPrint('key-day-light-saving: $value');
                  },
                ),
                SwitchSettingsTile(
                  settingKey: 'key-dark-mode',
                  title: 'Dark Mode',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: const Icon(Icons.palette),
                  onChange: (value) {
                    debugPrint('jey-dark-mode: $value');
                  },
                ),
              ],
            ),
            ExpandableSettingsTile(
              title: 'Quick setting 2',
              subtitle: 'Expandable Settings',
              expanded: true,
              children: <Widget>[
                CheckboxSettingsTile(
                  settingKey: 'key-day-light-savings-2',
                  title: 'Daylight Time Saving',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: const Icon(Icons.timelapse),
                  onChange: (value) {
                    debugPrint('key-day-light-savings-2: $value');
                  },
                ),
                SwitchSettingsTile(
                  settingKey: 'key-dark-mode-2',
                  title: 'Dark Mode',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: const Icon(Icons.palette),
                  onChange: (value) {
                    debugPrint('key-dark-mode-2: $value');
                  },
                ),
              ],
            ),
          ],
        ),
        SettingsGroup(
          title: 'Multiple choice settings',
          children: <Widget>[
            RadioSettingsTile<int>(
              title: 'Preferred Sync Period',
              settingKey: 'key-radio-sync-period',
              values: const <int, String>{
                0: 'Never',
                1: 'Daily',
                7: 'Weekly',
                15: 'Fortnight',
                30: 'Monthly',
              },
              selected: 0,
              onChange: (value) {
                debugPrint('key-radio-sync-period: $value');
              },
            ),
            DropDownSettingsTile<int>(
              title: 'E-Mail View',
              settingKey: 'key-dropdown-email-view',
              values: const <int, String>{
                2: 'Simple',
                3: 'Adjusted',
                4: 'Normal',
                5: 'Compact',
                6: 'Squizzed',
              },
              selected: 2,
              onChange: (value) {
                debugPrint('key-dropdown-email-view: $value');
              },
            ),
          ],
        ),
        ModalSettingsTile(
          title: 'Group Settings',
          subtitle: 'Same group settings but in a dialog',
          children: <Widget>[
            SimpleRadioSettingsTile(
              title: 'Sync Settings',
              settingKey: 'key-radio-sync-settings',
              values: const <String>[
                'Never',
                'Daily',
                'Weekly',
                'Fortnight',
                'Monthly',
              ],
              selected: 'Daily',
              onChange: (value) {
                debugPrint('key-radio-sync-settings: $value');
              },
            ),
            SimpleDropDownSettingsTile(
              title: 'Beauty Filter',
              settingKey: 'key-dropdown-beauty-filter',
              values: const <String>[
                'Simple',
                'Normal',
                'Little Special',
                'Special',
                'Extra Special',
                'Bizarre',
                'Horrific',
              ],
              selected: 'Special',
              onChange: (value) {
                debugPrint('key-dropdown-beauty-filter: $value');
              },
            )
          ],
        ),
        ExpandableSettingsTile(
          title: 'Expandable Group Settings',
          subtitle: 'Group of settings (expandable)',
          children: <Widget>[
            RadioSettingsTile<double>(
              title: 'Beauty Filter',
              settingKey: 'key-radio-beauty-filter-expandable',
              values: <double, String>{
                1.0: 'Simple',
                1.5: 'Normal',
                2.0: 'Little Special',
                2.5: 'Special',
                3.0: 'Extra Special',
                3.5: 'Bizarre',
                4.0: 'Horrific',
              },
              selected: 2.5,
              onChange: (value) {
                debugPrint('key-radio-beauty-filter-expandable: $value');
              },
            ),
            DropDownSettingsTile<int>(
              title: 'Preferred Sync Period',
              settingKey: 'key-dropdown-sync-period-2',
              values: const <int, String>{
                0: 'Never',
                1: 'Daily',
                7: 'Weekly',
                15: 'Fortnight',
                30: 'Monthly',
              },
              selected: 0,
              onChange: (value) {
                debugPrint('key-dropdown-sync-period-2: $value');
              },
            )
          ],
        ),
        SettingsGroup(
          title: 'Other settings',
          children: <Widget>[
            SliderSettingsTile(
              title: 'Volume [Auto-Adjusting to 20]',
              settingKey: 'key-slider-volume',
              defaultValue: 20,
              min: 0,
              max: 100,
              step: 1,
              leading: const Icon(Icons.volume_up),
              decimalPrecision: 0,
              onChange: (value) {
                debugPrint('\n===== on change end =====\n'
                    'key-slider-volume: $value'
                    '\n==========\n');
                Future.delayed(const Duration(seconds: 1), () {
                  // Reset value only if the current value is not 20
                  if (Settings.getValue<double>('key-slider-volume') != 20) {
                    debugPrint('\n===== on change end =====\n'
                        'Resetting value to 20'
                        '\n==========\n');
                    Settings.setValue<double>('key-slider-volume', 20.0,
                        notify: true);
                  }
                });
              },
            ),
            ColorPickerSettingsTile(
              settingKey: 'key-color-picker',
              title: 'Accent Color',
              defaultValue: Colors.blue,
              onChange: (value) {
                debugPrint('key-color-picker: $value');
              },
            )
          ],
        ),
        ModalSettingsTile(
          title: 'Other settings',
          subtitle: 'Other Settings in a Dialog',
          children: <Widget>[
            SliderSettingsTile(
              title: 'Custom Ratio',
              settingKey: 'key-custom-ratio-slider-2',
              defaultValue: 2.5,
              min: 1,
              max: 5,
              step: 0.1,
              decimalPrecision: 1,
              leading: const Icon(Icons.aspect_ratio),
              onChange: (value) {
                debugPrint('\n===== on change =====\n'
                    'key-custom-ratio-slider-2: $value'
                    '\n==========\n');
              },
              onChangeStart: (value) {
                debugPrint('\n===== on change start =====\n'
                    'key-custom-ratio-slider-2: $value'
                    '\n==========\n');
              },
              onChangeEnd: (value) {
                debugPrint('\n===== on change end =====\n'
                    'key-custom-ratio-slider-2: $value'
                    '\n==========\n');
              },
            ),
            ColorPickerSettingsTile(
              settingKey: 'key-color-picker-2',
              title: 'Accent Picker',
              defaultValue: Colors.blue,
              onChange: (value) {
                debugPrint('key-color-picker-2: $value');
              },
            )
          ],
        )
      ],
    );
  }
}
