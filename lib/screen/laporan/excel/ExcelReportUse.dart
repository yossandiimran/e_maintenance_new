import 'package:excel/excel.dart' as xl;

import 'package:e_maintenance/core/utils/app_result.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelDownloadSaver.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelStoragePermission.dart';

class ExcelReportUser {
  Future<AppResult<String>> exportUserReport({
    required List<UserReportEntry> data,
    required UserReportQuery query,
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
      xl.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1),
    );

    excel.appendRow('Sheet1', _row(<dynamic>['Laporan User']));
    excel.appendRow('Sheet1', _row(<dynamic>['']));
    excel.appendRow(
        'Sheet1', _row(<dynamic>['Jenis Cek : ${query.inspectionKind.label}']));
    excel.appendRow(
      'Sheet1',
      _row(<dynamic>[
        'Periode Tanggal : ${AppDateUtils.formatDisplay(query.startDate)} - ${AppDateUtils.formatDisplay(query.endDate)}',
      ]),
    );

    final dateRange =
        AppDateUtils.buildDateRange(query.startDate, query.endDate);
    excel.appendRow(
      'Sheet1',
      _row(<dynamic>[
        'NO',
        'NAMA USER',
        'LOKASI',
        ...dateRange.map(AppDateUtils.formatDisplay),
        'Dilakukan',
        'Tidak',
      ]),
    );

    for (var index = 0; index < data.length; index++) {
      excel.appendRow('Sheet1', _buildDataRow(data[index], index, dateRange));
    }

    final fileName = 'Report(${query.startDate}-${query.endDate})User.xlsx';
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

  List<xl.CellValue?> _buildDataRow(
      UserReportEntry entry, int index, List<String> dateRange) {
    final values = <dynamic>[
      index + 1,
      entry.name,
      entry.location,
    ];

    var doneCount = 0;
    var missedCount = 0;

    for (final date in dateRange) {
      if (entry.performedDates.contains(date)) {
        doneCount++;
        values.add('OK');
      } else {
        missedCount++;
        values.add('X');
      }
    }

    values
      ..add(doneCount)
      ..add(missedCount);

    return _row(values);
  }

  List<xl.CellValue?> _row(List<dynamic> values) {
    return values.map((value) => xl.TextCellValue('${value ?? ''}')).toList();
  }
}
