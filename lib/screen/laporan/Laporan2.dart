// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, await_only_futures, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, unused_local_variable
part of "../../header.dart";

class Laporan2 extends StatefulWidget {
  const Laporan2({Key? key}) : super(key: key);

  @override
  Laporan2State createState() => Laporan2State();
}

class Laporan2State extends State<Laporan2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController TglAwalController = TextEditingController();
  TextEditingController TglAkhirController = TextEditingController();
  TextEditingController werksController = TextEditingController();
  bool loading = false;
  List data = [];
  String jenisCek = "1";
  DateTime selectedDate = DateTime.now();
  var customFormatView = DateFormat('dd-MM-yyyy');
  var customFormat = DateFormat('yyyy-MM-dd');
  var dateList = [];
  final List _listJenisCek = ["1", "2", "3", "4"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Laporan User"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: defBlack1,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: widget.decCont(defBlack1, 50, 50, 0, 0),
              height: kToolbarHeight * 8,
            ),
          ),
          loading == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox(
                  height: global.getHeight(context),
                  child: Column(
                    children: [
                      Container(
                        height: global.getHeight(context) / 3.2,
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: global.getWidth(context) / 3,
                                    child: TextField(
                                      controller: werksController,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.location_city_rounded, color: defPurple),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                        hintText: "Lokasi",
                                      ),
                                      readOnly: false,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: global.getWidth(context) / 3,
                                    child: DropdownButton(
                                      hint: Text("Jenis Cek"),
                                      underline: Container(
                                        height: 1,
                                        color: Colors.black54,
                                      ),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      value: jenisCek,
                                      items: _listJenisCek.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            (value == "1"
                                                ? "Harian"
                                                : (value == "2"
                                                    ? "Mingguan"
                                                    : (value == "3" ? "Bulanan" : "Tutup Pabrik"))),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          jenisCek = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(children: <Widget>[
                                Flexible(
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      controller: TglAwalController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Tanggal Awal.',
                                        hintText: 'Tanggal Awal.',
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.date_range,
                                    size: 35,
                                  ),
                                  tooltip: 'Tanggal',
                                  onPressed: () {
                                    setState(() {
                                      showPickerTglAwal(context);
                                    });
                                  },
                                ),
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(children: <Widget>[
                                Flexible(
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      controller: TglAkhirController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Tanggal Akhir.',
                                        hintText: 'Tanggal Akhir.',
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.date_range,
                                    size: 35,
                                  ),
                                  tooltip: 'Tanggal',
                                  onPressed: () {
                                    setState(() {
                                      showPickerTglAkhir(context);
                                    });
                                  },
                                ),
                              ]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    getDatalaporan();
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: widget.decCont2(defBlue, 10, 10, 10, 10),
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Icon(Icons.search_rounded, color: defWhite),
                                          Text(" Cari", style: textStyling.defaultWhiteBold(14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    downloadExcel();
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: widget.decCont2(defGreen, 10, 10, 10, 10),
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text("Excel ", style: textStyling.defaultWhiteBold(14)),
                                          Icon(Icons.file_copy_rounded, color: defWhite),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: widget.decCont2(defWhite, 10, 10, 10, 10),
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        height: global.getHeight(context) / 1.8,
                        child: data.isNotEmpty
                            ? SingleChildScrollView(
                                child: Column(
                                  children: getTableDetail(),
                                ),
                              )
                            : Center(
                                child: Text("Tidak ada data !"),
                              ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  List<Widget> getTableDetail() {
    List<Widget> ret = [];
    ret.add(SizedBox(height: 10));
    for (var i = 0; i < data.length; i++) {
      ret.add(
        ListTileTheme(
          child: ExpansionTile(
            title: Text(data[i]["name"], style: textStyling.customColor(15, defBlack1)),
            children: getIconTrailing(data[i]["todo"]),
          ),
        ),
      );
    }
    return ret;
  }

  List<Widget> getIconTrailing(todo) {
    var showEmptyDate = dateList.where((item) => !todo.any((obj) => obj['tanggal'] == item)).toList();
    List<Widget> ret = [];
    if (showEmptyDate.isEmpty) {
      ret.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.check_circle_outline_rounded, color: defGreen),
      ));
      ret.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text("User melakukan cek secara berkala", style: textStyling.customColor(15, defGreen)),
      ));
    } else {
      ret.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.topLeft,
        child: Text("Daftar tanggal yang tidak dilakukan pengecekan : "),
      ));
      ret.add(SizedBox(height: 5));
      for (var j = 0; j < showEmptyDate.length; j++)
        ret.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(" - " + global.convertDate(showEmptyDate[j]), style: textStyling.customColorBold(14, defRed)),
        ));
    }

    ret.add(SizedBox(height: 10));

    return ret;
  }

  getDatalaporan() async {
    if (werksController.text == "" || TglAwalController.text == "" || TglAkhirController.text == "") {
      return alert.alertWarning(context: context, text: "Silahkan lengkapi inputan !");
    }

    dateList = getDateRangeList(
      global.parseDate(TglAwalController.text, ""),
      global.parseDate(TglAkhirController.text, ""),
    );

    Map obj = {
      "werks": werksController.text,
      "tgl_awal": TglAwalController.text,
      "tgl_akhir": TglAkhirController.text,
      "jenis_cek": jenisCek,
    };
    data = await ReportService(context: context, objParam: obj).getUserReport();
    setState(() {});
  }

  downloadExcel() {
    if (data.isEmpty) return alert.alertWarning(context: context, text: "Data tidak ditemukan !");
    Map obj = {
      "tglAwal": TglAwalController.text,
      "tglAkhir": TglAkhirController.text,
      "dateList": dateList,
      "jenisCek": (jenisCek == "1"
          ? "Harian"
          : (jenisCek == "2" ? "Mingguan" : (jenisCek == "3" ? "Bulanan" : "Tutup Pabrik"))),
    };
    ExcelReportUser(context: context).exportUserReport(data: data, obj: obj);
  }

  List<String> getDateRangeList(DateTime startDate, DateTime endDate) {
    final dateList = <String>[];

    for (var date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      dateList.add(dateString);
    }

    return dateList;
  }

  Future<void> showPickerTglAwal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2018), lastDate: DateTime(2101));

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        TglAwalController.text = '${customFormat.format(selectedDate)}';
      });
    }
  }

  Future<void> showPickerTglAkhir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: selectedDate,
      lastDate: DateTime(2101),
    );

    setState(() {
      selectedDate = picked!;
      TglAkhirController.text = '${customFormat.format(selectedDate)}';
    });
  }
}
