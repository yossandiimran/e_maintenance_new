import 'dart:convert';

import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/helper/preference.dart';
import 'package:e_maintenance/model/app_models.dart';

class ReportService {
  ReportService({
    required AppApiClient apiClient,
    required AppPreferences preferences,
  })  : _apiClient = apiClient,
        _preferences = preferences;

  final AppApiClient _apiClient;
  final AppPreferences _preferences;

  Future<AppResult<List<StorageLocation>>> fetchStorageLocations(UserSession session) async {
    try {
      final response = await _apiClient.postManual(
        'getsloc',
        body: _credentialPayload(session: session, location: session.werks),
      ).timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final locations = (decoded['T_SLOC'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => StorageLocation.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);

      return AppResult<List<StorageLocation>>.success(locations);
    } catch (error) {
      AppLogger.error('Failed to fetch storage locations', error);
      return const AppResult<List<StorageLocation>>.failure('Daftar lokasi aset belum berhasil dimuat.');
    }
  }

  Future<AppResult<List<VehicleCatalogItem>>> fetchVehicles({
    required UserSession session,
    required String location,
  }) async {
    try {
      final response = await _apiClient.postManual(
        'getlkend',
        body: _credentialPayload(session: session, location: location),
      ).timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final vehicles = (decoded['T_KEND'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => VehicleCatalogItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);

      return AppResult<List<VehicleCatalogItem>>.success(vehicles);
    } catch (error) {
      AppLogger.error('Failed to fetch vehicles by location', error);
      return const AppResult<List<VehicleCatalogItem>>.failure('Daftar kendaraan belum berhasil dimuat.');
    }
  }

  Future<AppResult<List<UserReportEntry>>> fetchUserReport(UserReportQuery query) async {
    try {
      final response = await _apiClient.postMain(
        'getUserReport',
        body: <String, String>{
          'werks': query.location,
          'tgl_awal': query.startDate,
          'tgl_akhir': query.endDate,
          'jenis_cek': query.inspectionKind.id,
        },
      ).timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] != true) {
        return const AppResult<List<UserReportEntry>>.failure('Laporan user tidak tersedia untuk filter ini.');
      }

      final items = (decoded['data'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => UserReportEntry.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
      return AppResult<List<UserReportEntry>>.success(items);
    } catch (error) {
      AppLogger.error('Failed to fetch user report', error);
      return const AppResult<List<UserReportEntry>>.failure('Laporan user belum berhasil dimuat.');
    }
  }

  Future<AppResult<List<TransactionReportItem>>> fetchTransactionReport(TransactionReportFilter filter) async {
    try {
      final response = await _apiClient.postMain(
        'getNewReport',
        body: <String, String>{
          'jenis_cek': filter.inspectionKind.id,
          'jenis_kendaraan': filter.vehicleType.id,
          'werks': filter.werks,
          'asloc': filter.storageLocation,
          'kendaraan': filter.vehicleSerialNumber,
          'tgl_awal': filter.startDate,
          'tgl_akhir': filter.endDate,
        },
      ).timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['hasil'] is String) {
        return AppResult<List<TransactionReportItem>>.failure('${decoded['hasil']}');
      }

      final items = (decoded['hasil'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => TransactionReportItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
      return AppResult<List<TransactionReportItem>>.success(items);
    } catch (error) {
      AppLogger.error('Failed to fetch transaction report', error);
      return const AppResult<List<TransactionReportItem>>.failure('Laporan transaksi belum berhasil dimuat.');
    }
  }

  Map<String, String> _credentialPayload({
    required UserSession session,
    required String location,
  }) {
    return <String, String>{
      'ASHOST': _preferences.getString('ashost'),
      'CLIENT': _preferences.getString('client'),
      'SYSNR': _preferences.getString('sysnr'),
      'USAP': session.usap,
      'PASS': _preferences.getString('pass'),
      'USERID': '${session.id}',
      'WERKS': location,
    };
  }
}
