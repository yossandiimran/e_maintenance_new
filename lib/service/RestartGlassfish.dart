import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/core/utils/app_result.dart';

class RestartGlassfishService {
  const RestartGlassfishService();

  Future<AppResult<bool>> checkConnection(String host) async {
    final sanitized = host.split(':').first.trim();
    if (sanitized.isEmpty) {
      return const AppResult<bool>.failure('Host belum diisi.');
    }

    try {
      final socket = await Socket.connect(sanitized, 80, timeout: const Duration(seconds: 5));
      socket.destroy();
      return const AppResult<bool>.success(true);
    } catch (error) {
      AppLogger.error('Host connectivity check failed', error);
      return const AppResult<bool>.failure('Host tidak dapat dijangkau. Pastikan VPN atau jaringan aktif.');
    }
  }

  Future<AppResult<String>> restartConnection() async {
    try {
      final response = await http.get(Uri.parse(AppEnvironment.resetConnectionUrl)).timeout(
            const Duration(seconds: 15),
          );
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final error = '${decoded['ERROR'] ?? ''}';
      if (error.isNotEmpty && error != 'Unregister Destination Failed!') {
        return AppResult<String>.failure(error);
      }

      return const AppResult<String>.success('Koneksi backend berhasil di-reset.');
    } catch (error) {
      AppLogger.error('Restart connection request failed', error);
      return const AppResult<String>.failure('Restart koneksi belum berhasil.');
    }
  }
}
