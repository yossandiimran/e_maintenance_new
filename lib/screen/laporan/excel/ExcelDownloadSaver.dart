import 'dart:io';

import 'package:flutter/services.dart';

class ExcelDownloadSaver {
  const ExcelDownloadSaver._();

  static const MethodChannel _channel =
      MethodChannel('e_maintenance/downloads');
  static const String _excelMimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  static Future<String> save({
    required String fileName,
    required List<int> bytes,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Export Excel hanya didukung di Android.');
    }

    final savedPath = await _channel.invokeMethod<String>(
      'saveToDownloads',
      <String, Object>{
        'fileName': fileName,
        'bytes': Uint8List.fromList(bytes),
        'mimeType': _excelMimeType,
      },
    );

    if (savedPath == null || savedPath.isEmpty) {
      throw const FileSystemException('File Excel tidak berhasil disimpan.');
    }

    return savedPath;
  }
}
