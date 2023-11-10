// ignore_for_file: prefer_typing_uninitialized_variables, non_ant_identifier_names, prefer__ructors, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, prefer_const_constructors, file_names, non_constant_identifier_names, duplicate_ignore, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unused_field, prefer_final_fields, prefer_if_null_operators, unused_local_variable, avoid_print, no_logic_in_create_state, prefer_const_literals_to_create_immutables

part of "../../header.dart";

class ListReportPage extends StatefulWidget {
  final jenis_cek, jenis_kendaraan, asloc, kendaraan, tgl_awal, tgl_akhir;
  ListReportPage(
      {Key? key, this.jenis_cek, this.jenis_kendaraan, this.asloc, this.kendaraan, this.tgl_awal, this.tgl_akhir})
      : super(key: key);

  @override
  _ListReportPageState createState() => _ListReportPageState(
        jenis_cek,
        jenis_kendaraan,
        asloc,
        kendaraan,
        tgl_awal,
        tgl_akhir,
      );
}

class _ListReportPageState extends State<ListReportPage> {
  final jenis_cek, jenis_kendaraan, asloc, kendaraan, tgl_awal, tgl_akhir;
  _ListReportPageState(this.jenis_cek, this.jenis_kendaraan, this.asloc, this.kendaraan, this.tgl_awal, this.tgl_akhir);
  final String url = 'public/api/getReportCekKendaraan';
  String _tanggal = "";
  Map<String, dynamic> data = {};
  Map groupedData = {};
  Map grupSnKendaraan = {};

  bool loading = true;

  // Csv exportToCsv =  Csv();

  @override
  void initState() {
    super.initState();
    _kirim(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: defWhite),
        ),
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Data Laporan", style: TextStyle(color: defWhite)),
        ),
        backgroundColor: defBlack1,
        elevation: 0,
        actions: <Widget>[
          data == null
              ? Text("")
              : IconButton(
                  icon: Icon(Icons.file_download, color: defWhite),
                  tooltip: "Download Excel",
                  onPressed: () {
                    downloadExcel();
                  },
                ),
        ],
      ),
      body: (loading == true
          ? Container() //Loading Card
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: (data == null ? Text("Data tidak ditemukan") : Column(children: getDataChildern())),
              ),
            )),
    );
  }

  downloadExcel() {
    if (data.isEmpty) return alert.alertWarning(context: context, text: "Data tidak ditemukan !");
    Map obj = {
      "tglAwal": tgl_awal,
      "tglAkhir": tgl_akhir,
      "jenisCek": (jenis_cek == "1"
          ? "Harian"
          : (jenis_cek == "2" ? "Mingguan" : (jenis_cek == "3" ? "Bulanan" : "Tutup Pabrik"))),
    };
    ExcelReportTransaksi(context: context).exportTransaksiReport(data: data, obj: obj);
  }

  List<Widget> getDataChildern() {
    List<Widget> dataColumn = <Widget>[];

    groupedData.forEach((snKendaraan, dataTanggal) {
      dataColumn.add(
        Container(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'Tanggal   : $snKendaraan',
              style: textStyling.customColorBold(16, defBlack2),
            ),
            children: getDataChildernChild(snKendaraan, dataTanggal),
          ),
        ),
      );
    });

    return dataColumn;
  }

  List<Widget> getDataChildernChild(snKendaraan, dataTanggal) {
    List<Widget> dataColumn = <Widget>[];
    dataTanggal.forEach((tanggal, data) {
      dataColumn.add(
        Container(
          decoration: widget.decCont(defBlack1, 10, 10, 10, 10),
          margin: EdgeInsets.all(5),
          child: ExpansionTile(
            title: Text('${data[0]["kendaraan"] ?? "-"}', style: textStyling.customColor(15, defWhite)),
            subtitle: Text(
              "SN    :  " + data[0]["sn_kendaraan"] + "\nPIC   : " + data[0]["nama"],
              style: textStyling.customColor(14, defWhite),
            ),
            children: getDetailChildern(data),
          ),
        ),
      );
    });
    return dataColumn;
  }

  List<Widget> getDetailChildern(data) {
    List<Widget> dataColumn = <Widget>[];
    data.forEach((element) {
      grupSnKendaraan[{element['sn_kendaraan']}] = (element['kendaraan'] ?? "-");

      dataColumn.add(
        ListTile(
          trailing: IconButton(
            onPressed: () {
              element['photo'] != "null"
                  ? showImg(element['nama'], element['photo'])
                  : alert.alertWarning(
                      context: context,
                      text: "Data Cek tidak ditemukan ! ",
                    );
            },
            icon: element["photo"] != "null"
                ? Icon(Icons.image_rounded, color: defGreen)
                : Icon(Icons.broken_image_rounded, color: defRed),
          ),
          title: Text(element["title"], style: textStyling.defaultWhite(16)),
          // subtitle: Text("Pic : ${element['nama']}", style: textStyling.defaultWhite(16)),
          leading: !element["_is_done"]
              ? Icon(Icons.remove_circle_outline_rounded, color: defRed)
              : Icon(Icons.check_circle, color: defGreen),
        ),
      );
    });
    return dataColumn;
  }

  Future<String> _kirim(String url) async {
    Map obj = {
      "jenis_cek": jenis_cek,
      "jenis_kendaraan": jenis_kendaraan,
      "asloc": asloc,
      "kendaraan": kendaraan,
      "tgl_awal": tgl_awal,
      "tgl_akhir": tgl_akhir
    };
    Map res = await ReportService(context: context, objParam: obj).getTransaksiReportNew();
    setState(() {
      if (res['hasil'] is String) {
        data = {};
      } else {
        data = {"hasil": res['hasil']};
      }
      print(data["hasil"]);

      var groupedDataSn = groupBySnKendaraan(res["hasil"]);
      groupedData = groupByTanggal(groupedDataSn);

      loading = false;
    });
    return 'success!';
  }

  groupBySnKendaraan(data) {
    final groupedData = {};

    for (final item in data) {
      final snKendaraan = item['tanggal'] as String;

      if (!groupedData.containsKey(snKendaraan)) {
        groupedData[snKendaraan] = [];
      }

      groupedData[snKendaraan]!.add(item);
    }

    return groupedData;
  }

  groupByTanggal(dataBySnKendaraan) {
    final groupedData = {};

    dataBySnKendaraan.forEach((snKendaraan, data) {
      final dataTanggal = {};

      for (final item in data) {
        final tanggal = item['sn_kendaraan'] as String;

        if (!dataTanggal.containsKey(tanggal)) {
          dataTanggal[tanggal] = [];
        }

        dataTanggal[tanggal]!.add(item);
      }

      groupedData[snKendaraan] = dataTanggal;
    });

    return groupedData;
  }

  showImg(String asset, String img) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(asset),
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.network(global.getFotoServiceUrl("photo/${img == null ? 'no-image.png' : img}")),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
