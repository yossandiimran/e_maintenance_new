import 'dart:convert';

import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/helper/preference.dart';
import 'package:e_maintenance/model/app_models.dart';

class AuthService {
  AuthService({
    required AppApiClient apiClient,
    required AppPreferences preferences,
  })  : _apiClient = apiClient,
        _preferences = preferences;

  final AppApiClient _apiClient;
  final AppPreferences _preferences;

  Future<AppResult<UserSession>> login({
    required String username,
    required String password,
    String? deviceToken,
  }) async {
    try {
      final response = await _apiClient.postMain(
        'login',
        body: <String, String>{
          'username': username.trim(),
          'password': password,
          'device_token': deviceToken ?? '',
          'app_version': AppEnvironment.appVersion,
        },
      ).timeout(const Duration(seconds: 12));

      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      AppLogger.debug('Login response', data);

      if (response.statusCode != 200) {
        return const AppResult<UserSession>.failure('Username atau password salah.');
      }

      if (data['success'] == false) {
        return AppResult<UserSession>.failure('${data['message'] ?? 'Login gagal.'}');
      }

      final sessionPayload = Map<String, dynamic>.from(data['for_session'] as Map? ?? <String, dynamic>{});
      final appVersion = '${sessionPayload['app_version'] ?? ''}';
      if (appVersion.isNotEmpty && appVersion != AppEnvironment.appVersion) {
        return const AppResult<UserSession>.failure(
          'Versi aplikasi tidak sesuai. Silakan update ke versi terbaru terlebih dahulu.',
        );
      }

      return AppResult<UserSession>.success(UserSession.fromLoginPayload(sessionPayload));
    } catch (error) {
      AppLogger.error('Login request failed', error);
      return const AppResult<UserSession>.failure('Terjadi kesalahan saat login. Coba lagi beberapa saat lagi.');
    }
  }

  Future<AppResult<Map<String, String>>> fetchOperationalSettings() async {
    try {
      final response = await _apiClient.getMain('getSetting').timeout(const Duration(seconds: 12));
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        return const AppResult<Map<String, String>>.failure('Format pengaturan server tidak dikenali.');
      }

      final values = <String, String>{};
      for (final item in decoded.cast<Map<String, dynamic>>()) {
        values['${item['name_setting'] ?? ''}'] = '${item['value'] ?? ''}';
      }

      return AppResult<Map<String, String>>.success(values);
    } catch (error) {
      AppLogger.error('Failed to fetch operational settings', error);
      return const AppResult<Map<String, String>>.failure('Pengaturan operasional tidak berhasil dimuat.');
    }
  }

  Future<void> cacheOperationalSettings(Map<String, String> values) {
    return _preferences.saveRemoteSettings(values);
  }

  Future<AppResult<void>> unregisterDevice({required int userId}) async {
    if (_preferences.manualServiceBaseUrl.isEmpty) {
      return const AppResult<void>.success(null);
    }

    try {
      await _apiClient.postManual('unregdes?USERID=$userId').timeout(const Duration(seconds: 10));
      return const AppResult<void>.success(null);
    } catch (error) {
      AppLogger.error('Failed to unregister device token', error);
      return const AppResult<void>.failure('Tidak dapat membersihkan token perangkat.');
    }
  }
}
