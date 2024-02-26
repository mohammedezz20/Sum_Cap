import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AudioRecordFileHelper {
  final String _recordDirectoryName = 'audio_recods';
  String? _appDirPah;
  Future<String> get appDirPath async {
    _appDirPah ??= (await getApplicationDocumentsDirectory()).path;
    return _appDirPah!;
  }

  Future<Directory> get getRecordDirectoryPath async {
    Directory recordDirectory =
        Directory(path.join((await appDirPath), _recordDirectoryName));
    if (!await recordDirectory.exists()) {
      await recordDirectory.create(recursive: true);
    }

    return recordDirectory;
  }

  deleteRecordFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      log('$filePath deleted');
    }
  }
}
