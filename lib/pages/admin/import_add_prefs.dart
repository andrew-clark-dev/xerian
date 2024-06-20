import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportAddPrefs extends Dialog {
  const ImportAddPrefs({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          var result = await FilePicker.platform.pickFiles();
          if (result != null) {
            processFile(result.files.single);
          } else {
            // User canceled the picker
          }
        } catch (_) {}
      },
      child: const Text('Pick File'),
    );
  }

  Future<void> processFile(PlatformFile file) async {
    File(file.path!)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach((l) => print('line: $l'));
  }
}
