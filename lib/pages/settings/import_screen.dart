import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:xerian/widgets/single_file_picker.dart';

class ImportScreen extends StatefulWidget {
  static const path = '/import';
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import')),
      body: const SettingsList(
        platform: DevicePlatform.web,
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.only(top: 40),
            tiles: [
              CustomSettingsTile(
                child: SingleFilePicker(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
