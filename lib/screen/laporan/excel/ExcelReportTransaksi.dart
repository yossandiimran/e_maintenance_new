import 'package:excel/excel.dart' as xl;

import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelDownloadSaver.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelStoragePermission.dart';

class ExcelReportTransaksi {
  Future<AppResult<String>> exportTransaksiReport({
    required List<TransactionReportItem> data,
    required TransactionReportFilter filter,
  }) async {
    final hasStoragePermission = await ExcelStoragePermission.ensureGranted();
    if (!hasStoragePermission) {
      return const AppResult<String>.failure(
        'Aktifkan izin akses file dari pengaturan aplikasi, lalu coba ekspor ulang.',
      );
    }

    final excel = xl.Excel.createExcel();
    excel.delete('Sheet1');
    excel['Sheet1'];

    excel.merge(
      'Sheet1',
      xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      xl.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1),
    );

    excel.appendRow('Sheet1', _row(<dynamic>['Laporan Cek Kendaraan']));
    excel.appendRow('Sheet1', _row(<dynamic>['']));
    excel.appendRow('Sheet1',
        _row(<dynamic>['Jenis Cek : ${filter.inspectionKind.label}']));
    excel.appendRow(
      'Sheet1',
      _row(<dynamic>[
        'Periode Tanggal : ${AppDateUtils.formatDisplay(filter.startDate)} - ${AppDateUtils.formatDisplay(filter.endDate)}',
      ]),
    );
    excel.appendRow(
      'Sheet1',
      _row(<dynamic>[
        'NO',
        'Tanggal',
        'Nama User',
        'Lokasi',
        'Kendaraan',
        'Checklist',
        'Status',
      ]),
    );

    for (var index = 0; index < data.length; index++) {
      final item = data[index];
      excel.appendRow(
        'Sheet1',
        _row(<dynamic>[
          index + 1,
          AppDateUtils.formatDisplay(item.date),
          item.userName,
          item.location,
          '${item.vehicleName} (${item.serialNumber})',
          item.title,
          item.isDone ? 'OK' : 'Belum',
        ]),
      );
    }

    final fileName =
        'Report(${filter.startDate}-${filter.endDate})CekKendaraan.xlsx';
    final fileBytes = excel.save();
    if (fileBytes == null) {
      return const AppResult<String>.failure(
          'File Excel tidak berhasil dibuat.');
    }

    final String outputFile;
    try {
      outputFile = await ExcelDownloadSaver.save(
        fileName: fileName,
        bytes: fileBytes,
      );
    } catch (_) {
      return const AppResult<String>.failure(
        'File Excel tidak berhasil disimpan ke folder Download.',
      );
    }

    return AppResult<String>.success(outputFile);
  }

  List<xl.CellValue?> _row(List<dynamic> values) {
    return values.map((value) => xl.TextCellValue('${value ?? ''}')).toList();
  }
}
