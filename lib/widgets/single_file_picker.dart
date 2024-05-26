import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SingleFilePicker extends StatelessWidget {
  const SingleFilePicker({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          var result = await FilePicker.platform.pickFiles();
          if (result != null) {
            uploadFile(result.files.first);
          } else {
            // User canceled the picker
          }
        } catch (_) {}
      },
      child: const Text('Pick File'),
    );
  }

  Future<void> uploadFile(PlatformFile file) async {
    final awsFile = AWSFile.fromData(file.bytes as List<int>);
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        path: StoragePath.fromString('import/account/${file.name}'),
      ).result;
      safePrint('Uploaded file: ${result.uploadedItem.path}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }
}
