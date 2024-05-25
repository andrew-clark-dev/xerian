import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SingleFilePicker extends StatefulWidget {
  const SingleFilePicker({super.key});

  @override
  State<SingleFilePicker> createState() => _SingleFilePickerState();
}

class _SingleFilePickerState extends State<SingleFilePicker> {
  File? file;
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          result = await FilePicker.platform.pickFiles();
          if (result != null) {
            if (!kIsWeb) {
              file = File(result!.files.single.path!);
            }
            setState(() {});
          } else {
            // User canceled the picker
          }
        } catch (_) {}
      },
      child: const Text('Pick File'),
    );
  }
}
