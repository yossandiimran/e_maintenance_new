// ignore_for_file: unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, file_names

part of "../../../header.dart";

class ExcelReportUser {
  final BuildContext context;
  ExcelReportUser({required this.context});
  exportUserReport({required data, Map? obj}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var excel = xl.Excel.createExcel();
    xl.CellIndex start = xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0);
    xl.CellIndex end = xl.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1);
    excel.merge("Sheet1", start, end);
    //Header
    excel.appendRow("Sheet1", _textRow([
      "Laporan User",
    ]));
    excel.appendRow("Sheet1", _textRow([
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ]));
    excel.appendRow("Sheet1", _textRow([
      "Jenis Cek : " + obj?["jenisCek"],
    ]));
    excel.appendRow("Sheet1", _textRow([
      "Periode Tanggal : " +
          global.convertDate(obj?["tglAwal"]).toString() +
          "-" +
          global.convertDate(obj?["tglAkhir"]).toString(),
    ]));
    excel.appendRow("Sheet1", _textRow([
      "NO",
      "NAMA USER",
      "LOKASI",
      for (var i = 0; i < obj?["dateList"].length; i++) global.convertDate(obj?["dateList"][i]),
      "Dilakukan",
      "Tidak",
    ]));
    //Styling Excel
    xl.Sheet sheetObject = excel['Sheet1'];

    xl.CellStyle cellStyle3 = xl.CellStyle(
      fontFamily: xl.getFontFamily(xl.FontFamily.Calibri),
      verticalAlign: xl.VerticalAlign.Center,
      bold: true,
      fontSize: 14,
    );
    xl.CellStyle cellStyle31 = xl.CellStyle(
      fontFamily: xl.getFontFamily(xl.FontFamily.Calibri),
      verticalAlign: xl.VerticalAlign.Center,
      bold: true,
    );
    xl.CellStyle cellStyle4 = xl.CellStyle(
      fontFamily: xl.getFontFamily(xl.FontFamily.Calibri),
      horizontalAlign: xl.HorizontalAlign.Center,
      verticalAlign: xl.VerticalAlign.Center,
      bold: true,
    );

    sheetObject.cell(xl.CellIndex.indexByString("A1")).cellStyle = cellStyle3;
    sheetObject.cell(xl.CellIndex.indexByString("A3")).cellStyle = cellStyle31;
    sheetObject.cell(xl.CellIndex.indexByString("A4")).cellStyle = cellStyle31;
    sheetObject.cell(xl.CellIndex.indexByString("A5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("B5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("C5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("D5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("E5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("F5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("G5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("H5")).cellStyle = cellStyle4;
    sheetObject.cell(xl.CellIndex.indexByString("I5")).cellStyle = cellStyle4;

    for (var j = 0; j < data.length; j++) {
      excel.appendRow("Sheet1", getData(data[j]["todo"], data[j], j, obj));
    }

    var name = obj?["tglAwal"] + "-" + obj?["tglAkhir"];
    var times = DateTime.now().millisecondsSinceEpoch;
    final String outputFile = '/storage/emulated/0/Download/Report($name)User.xlsx';
    print(outputFile);
    var fileBytes = excel.save();

    if (fileBytes != null) {
      File(path.join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    if (!context.mounted) return;
    alert.alertSuccess(context: context, text: "File saved to $outputFile");
  }

  List<xl.CellValue?> getData(todo, data, index, obj) {
    List ret = [];
    ret.add((index + 1).toString());
    ret.add(data["name"]);
    ret.add(data["werks"]);

    var listFilter = List<String>.filled(obj["dateList"].length, '-');

    for (var i = 0; i < todo.length; i++) {
      var tgl = todo[i];
      var num = tgl['tanggal'];

      if (obj["dateList"].contains(num)) {
        var index = obj["dateList"].indexOf(num);
        listFilter[index] = num;
      }
    }

    var dilakukan = 0, tidakDilakukan = 0;

    for (var element in listFilter) {
      if (element != "-") {
        dilakukan++;
        ret.add("OK");
      } else {
        tidakDilakukan++;
        ret.add("X");
      }
    }
    ret.add(dilakukan);
    ret.add(tidakDilakukan);

    return _textRow(ret);
  }

  List<xl.CellValue?> _textRow(List<dynamic> values) {
    return values.map((value) => xl.TextCellValue('${value ?? ''}')).toList();
  }
}
