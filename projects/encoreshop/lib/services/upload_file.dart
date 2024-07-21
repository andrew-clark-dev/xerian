import 'dart:typed_data';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_common/vm.dart';

import 'package:file_picker/file_picker.dart';

class UploadFile {
  Future<void> uploadDataImportFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name.toLowerCase();

      // Upload file
      await uploadFile('uploads/imports/$fileName', fileBytes!);
    }
  }

  Future<void> uploadFile(String path, Uint8List data) async {
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFilePlatform.fromData(data),
        path: StoragePath.fromString(path),
      ).result;
      safePrint('Uploaded file: ${result.uploadedItem.path}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }
}
