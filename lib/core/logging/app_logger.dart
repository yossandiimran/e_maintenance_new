import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void debug(String message, [Object? payload]) {
    if (!kDebugMode) {
      return;
    }

    if (payload == null) {
      debugPrint('[e-maintenance] $message');
      return;
    }

    debugPrint('[e-maintenance] $message: $payload');
  }

  static void error(String message, [Object? payload]) {
    if (!kDebugMode) {
      return;
    }

    if (payload == null) {
      debugPrint('[e-maintenance][error] $message');
      return;
    }

    debugPrint('[e-maintenance][error] $message: $payload');
  }
}
