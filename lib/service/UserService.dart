import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/model/app_models.dart';

class UserService {
  UserService({required AppApiClient apiClient}) : _apiClient = apiClient;

  final AppApiClient _apiClient;

  Future<AppResult<List<AppUser>>> fetchUsers(
      {required String location}) async {
    try {
      final response = await _apiClient.postMain(
        'userList',
        body: <String, String>{'lokasi': location},
      ).timeout(const Duration(seconds: 12));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] != true) {
        return const AppResult<List<AppUser>>.failure(
            'Daftar user tidak berhasil dimuat.');
      }

      final users = (decoded['data'] as List<dynamic>? ?? <dynamic>[])
          .map((item) =>
              AppUser.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
      return AppResult<List<AppUser>>.success(users);
    } catch (error) {
      AppLogger.error('Failed to fetch users', error);
      return const AppResult<List<AppUser>>.failure(
          'Gagal mengambil data user.');
    }
  }

  Future<AppResult<void>> saveUser(UserFormData data) async {
    try {
      final username = data.username.trim();
      final location = data.location.trim();
      const usersRoleId = '4';
      final id = (data.id ?? '').trim().isNotEmpty ? data.id!.trim() : '0';

      final response = await _apiClient.postMain(
        'userAdd',
        body: <String, String>{
          'username': username,
          'werks': location,
          'id_jenis_user': usersRoleId,
          'id': id,
        },
      ).timeout(const Duration(seconds: 12));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      AppLogger.debug('Save user response', decoded);
      if (decoded['success'] != true) {
        final message =
            '${decoded['message'] ?? decoded['error'] ?? decoded['hasil'] ?? ''}'
                .trim();
        return AppResult<void>.failure(
            message.isNotEmpty ? message : 'Penyimpanan user gagal.');
      }

      return const AppResult<void>.success(null);
    } on http.ClientException catch (error) {
      AppLogger.error('Failed to save user', error);
      if (kIsWeb) {
        return const AppResult<void>.failure(
          'Browser memblokir koneksi ke backend. Untuk Web, aktifkan CORS di server atau jalankan mode development tanpa web security.',
        );
      }
      return const AppResult<void>.failure(
          'Koneksi ke backend gagal. Pastikan jaringan atau host aktif sudah benar.');
    } catch (error) {
      AppLogger.error('Failed to save user', error);
      return const AppResult<void>.failure(
          'Data user belum berhasil disimpan.');
    }
  }

  Future<AppResult<void>> deleteUser(String id) async {
    try {
      final response = await _apiClient.postMain(
        'userDelete',
        body: <String, String>{'id': id},
      ).timeout(const Duration(seconds: 12));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] != true) {
        return const AppResult<void>.failure('User tidak berhasil dihapus.');
      }

      return const AppResult<void>.success(null);
    } catch (error) {
      AppLogger.error('Failed to delete user', error);
      return const AppResult<void>.failure('Penghapusan user gagal.');
    }
  }
}
