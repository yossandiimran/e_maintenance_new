// ignore_for_file: unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures

part of "../../../header.dart";

class ExcelReportUser {
  final BuildContext context;
  ExcelReportUser({required this.context});
  exportUserReport({required data, Map? obj}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var excel = Excel.createExcel();
    CellIndex start = CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0);
    CellIndex end = CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1);
    excel.merge("Sheet1", start, end);
    //Header
    excel.appendRow("Sheet1", [
      "Laporan User",
    ]);
    excel.appendRow("Sheet1", [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ]);
    excel.appendRow("Sheet1", [
      "Jenis Cek : " + obj?["jenisCek"],
    ]);
    excel.appendRow("Sheet1", [
      "Periode Tanggal : " + global.convertDate(obj?["tglAwal"]) + "-" + global.convertDate(obj?["tglAkhir"]),
    ]);
    excel.appendRow("Sheet1", [
      "NO",
      "NAMA USER",
      "LOKASI",
      for (var i = 0; i < obj?["dateList"].length; i++) global.convertDate(obj?["dateList"][i]),
      "Dilakukan",
      "Tidak",
    ]);
    //Styling Excel
    Sheet sheetObject = excel['Sheet1'];

    CellStyle cellStyle3 = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      verticalAlign: VerticalAlign.Center,
      bold: true,
      fontSize: 14,
    );
    CellStyle cellStyle31 = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      verticalAlign: VerticalAlign.Center,
      bold: true,
    );
    CellStyle cellStyle4 = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
    );

    sheetObject.cell(CellIndex.indexByString("A1")).cellStyle = cellStyle3;
    sheetObject.cell(CellIndex.indexByString("A3")).cellStyle = cellStyle31;
    sheetObject.cell(CellIndex.indexByString("A4")).cellStyle = cellStyle31;
    sheetObject.cell(CellIndex.indexByString("A5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("B5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("C5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("D5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("E5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("F5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("G5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("H5")).cellStyle = cellStyle4;
    sheetObject.cell(CellIndex.indexByString("I5")).cellStyle = cellStyle4;

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
    alert.alertSuccess(context: context, text: "File saved to $outputFile");
  }

  getData(todo, data, index, obj) {
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

    return ret;
  }
}
