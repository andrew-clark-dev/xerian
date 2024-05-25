import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:xerian/pages/settings/import_screen.dart';

import 'web_chrome_addresses_settings.dart';

class WebChromeSettings extends StatelessWidget {
  static const path = '/settings';
  const WebChromeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        platform: DevicePlatform.web,
        sections: [
          SettingsSection(
            title: const Text('Auto-fill'),
            tiles: [
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.vpn_key),
                title: const Text('Passwords'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.credit_card_outlined),
                title: const Text('Payment methods'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {
                  context.push(WebChromeAddressesScreen.path);
                },
                leading: const Icon(Icons.location_on),
                title: const Text('Addresses and more'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {
                  context.push(ImportScreen.path);
                },
                leading: const Icon(Icons.location_on),
                title: const Text('Import'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Privacy and security'),
            tiles: [
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.delete),
                title: const Text('Clear browsing data'),
                description:
                    const Text('Clear history, cookies, cache and more'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.web),
                title: const Text('Cookies and other site data'),
                description: const Text(
                    'Third-party cookies are blocked in Incognito mode'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.security),
                title: const Text('Security'),
                description: const Text(
                    'Safe Browsing (protection from dangerous sites) and other security settings'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.settings),
                title: const Text('Site settings'),
                description: const Text(
                    'Controls what information sites can use and show (location, camera, pop-ups and more)'),
              ),
              SettingsTile.navigation(
                onPressed: (_) {},
                leading: const Icon(Icons.account_balance_outlined),
                title: const Text('Privacy Sandbox'),
                description: const Text('Trial features are on'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
