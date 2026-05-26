import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class ExcelStoragePermission {
  const ExcelStoragePermission._();

  static Future<bool> ensureGranted() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final manageStatus = await Permission.manageExternalStorage.status;
    if (manageStatus.isGranted) {
      return true;
    }

    final requestedManageStatus =
        await Permission.manageExternalStorage.request();
    if (requestedManageStatus.isGranted) {
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
