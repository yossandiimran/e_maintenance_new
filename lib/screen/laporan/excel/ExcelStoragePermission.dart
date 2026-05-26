import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelStoragePermission {
  const ExcelStoragePermission._();

  static const MethodChannel _channel =
      MethodChannel('e_maintenance/downloads');

  static Future<bool> ensureGranted() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final sdkInt = await _channel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    if (sdkInt >= 29) {
      return true;
    }

    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      return true;
    }

    final requestedStorageStatus = await Permission.storage.request();
    if (requestedStorageStatus.isGranted) {
      return true;
    }

    await openAppSettings();
    return false;
  }
}
