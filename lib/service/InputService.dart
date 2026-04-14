import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/helper/preference.dart';
import 'package:e_maintenance/model/app_models.dart';

class InputService {
  InputService({
    required AppApiClient apiClient,
    required AppPreferences preferences,
  })  : _apiClient = apiClient,
        _preferences = preferences;

  final AppApiClient _apiClient;
  final AppPreferences _preferences;

  Future<AppResult<List<ChecklistItem>>> fetchChecklist({
    required InspectionKind inspectionKind,
    required bool isForklift,
  }) async {
    try {
      final endpoint = isForklift ? 'getDataTodoForklip/${inspectionKind.id}' : 'getDataTodoMobil/${inspectionKind.id}';
      final response = await _apiClient.getMain(endpoint).timeout(const Duration(seconds: 12));
      final decoded = jsonDecode(response.body) as List<dynamic>;
      final items = decoded
          .map((item) => ChecklistItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
      return AppResult<List<ChecklistItem>>.success(items);
    } catch (error) {
      AppLogger.error('Failed to fetch checklist', error);
      return const AppResult<List<ChecklistItem>>.failure('Checklist inspeksi belum berhasil dimuat.');
    }
  }

  Future<AppResult<VehicleInfo>> fetchVehicleInfo({
    required String barcode,
    required UserSession session,
  }) async {
    try {
      final response = await _apiClient.postManual(
        'getkend',
        body: _operationalPayload(session: session, extra: <String, String>{'SERNR': barcode}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      AppLogger.debug('fetchVehicleInfo raw response keys', data.keys.toList());
      AppLogger.debug('fetchVehicleInfo WERKS field', data['WERKS'] ?? data['werks'] ?? data['Werks'] ?? '(not found)');
      final vehicleInfo = VehicleInfo.fromJson(data);
      if (vehicleInfo.hasError || vehicleInfo.materialDescription.isEmpty) {
        return AppResult<VehicleInfo>.failure(
          vehicleInfo.message.isNotEmpty ? vehicleInfo.message : 'Data kendaraan tidak ditemukan.',
        );
      }

      return AppResult<VehicleInfo>.success(vehicleInfo);
    } catch (error) {
      AppLogger.error('Failed to fetch vehicle information', error);
      return const AppResult<VehicleInfo>.failure('Gagal mengambil data kendaraan dari server.');
    }
  }

  Future<AppResult<String>> uploadPhoto(File image) async {
    try {
      final streamed = await _apiClient.uploadMain(
        'upload',
        file: image,
        fields: const <String, String>{'kode_customer': ''},
      ).timeout(const Duration(seconds: 20));
      final responseString = await streamed.stream.bytesToString();
      final decoded = jsonDecode(responseString) as Map<String, dynamic>;

      if ('${decoded['hasil'] ?? ''}'.toLowerCase() == 'gagal') {
        return const AppResult<String>.failure('Upload foto gagal. Coba ambil ulang foto inspeksi.');
      }

      return AppResult<String>.success(path.basename(image.path));
    } catch (error) {
      AppLogger.error('Failed to upload inspection photo', error);
      return const AppResult<String>.failure('Foto inspeksi tidak berhasil diunggah.');
    }
  }

  Future<AppResult<String>> submitInspection({
    required List<ChecklistItem> items,
    required InspectionKind inspectionKind,
    required String barcode,
    required String vehicleName,
    required String userName,
    required String location,
    required DateTime inspectionDate,
  }) async {
    try {
      String latestMessage = 'Inspeksi berhasil disimpan.';
      for (final item in items) {
        final payload = <String, dynamic>{
          'title': item.title,
          'tanggal': AppDateUtils.formatApi(inspectionDate),
          'jenis_cek': inspectionKind.id,
          'jenis_kendaraan': item.vehicleCategory,
          'nama': userName,
          'sn_kendaraan': barcode,
          'kendaraan': vehicleName,
          'is_done': item.isDone.toString(),
          'werks': location,
          'keterangan': item.note,
          'photo': item.photoFileName,
        };

        final response = await _apiClient.postMainJson(
          'addCekKendaraan',
          body: jsonEncode(payload),
          headers: const <String, String>{
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));

        dynamic decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (_) {
          decoded = null;
        }

        if (response.statusCode >= 400) {
          return const AppResult<String>.failure('Penyimpanan inspeksi gagal di server.');
        }

        if (decoded is List && decoded.isNotEmpty) {
          latestMessage = '${decoded.first}';
        }
      }

      return AppResult<String>.success(latestMessage);
    } catch (error) {
      AppLogger.error('Failed to submit inspection checklist', error);
      return const AppResult<String>.failure('Checklist inspeksi belum berhasil disimpan.');
    }
  }

  Map<String, String> _operationalPayload({
    required UserSession session,
    Map<String, String>? extra,
  }) {
    return <String, String>{
      'ASHOST': _preferences.getString('ashost'),
      'CLIENT': _preferences.getString('client'),
      'SYSNR': _preferences.getString('sysnr'),
      'USAP': session.usap,
      'PASS': _preferences.getString('pass'),
      'USERID': '${session.id}',
      'WERKS': session.werks,
      ...?extra,
    };
  }
}
