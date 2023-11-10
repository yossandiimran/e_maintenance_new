// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, await_only_futures, unnecessary_null_comparison
part of "../../header.dart";

class Laporan1 extends StatefulWidget {
  const Laporan1({Key? key}) : super(key: key);

  @override
  _Laporan1State createState() => _Laporan1State();
}

class _Laporan1State extends State<Laporan1> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController TglAwalController = TextEditingController();
  TextEditingController TglAkhirController = TextEditingController();
  String usap = "", psap = "", werks = "";
  var data;
  var dataLkend;
  var error;
  String message = "";

  String _valJenisCek = "1", _valJenisKendaraan = "1";
  var _valAsloc;
  var valKendaraan;
  String sn = "";
  DateTime selectedDate = DateTime.now();
  var customFormat = DateFormat('yyyy-MM-dd');

  final List _listJenisCek = ["1", "2", "3", "4"];
  final List _listJenisKendaraan = ["1", "2"];

  getPref() async {
    setState(() {
      usap = preference.getData("usap");
      psap = preference.getData("psap");
      werks = preference.getData("werks");
      getSloc(usap, psap, werks);
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: defWhite),
        ),
        title: Text("Laporan", style: TextStyle(color: defWhite)),
        backgroundColor: defBlack1,
        elevation: 0,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              decoration: widget.decCont2(defWhite, 20, 20, 20, 20),
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton(
                      hint: Text("Jenis Cek"),
                      underline: Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      value: _valJenisCek,
                      items: _listJenisCek.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text((value == "1"
                              ? "Harian"
                              : (value == "2" ? "Mingguan" : (value == "3" ? "Bulanan" : "Tutup Pabrik")))),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _valJenisCek = value.toString();
                        });
                      },
                    ),
                    DropdownButton(
                      hint: Text("Pilih Jenis Aset"),
                      underline: Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      value: _valJenisKendaraan,
                      items: _listJenisKendaraan.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text((value == "1" ? "Mobil" : "Forklip")),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _valJenisKendaraan = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                slocList(),
                SizedBox(height: 10.0),
                lkendList(),
                SizedBox(height: 10.0),
                Row(children: <Widget>[
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
                SizedBox(height: 10.0),
                Row(children: <Widget>[
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
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          disabledForegroundColor: Colors.grey.withOpacity(0.38),
                        ),
                        onPressed: () {
                          if (_valJenisCek == null) {
                            alert.alertWarning(context: context, text: "Jenis cek belum di pilih");
                          } else if (_valJenisKendaraan == null) {
                            alert.alertWarning(context: context, text: "Jenis kendaraan belum di pilih");
                          } else if (TglAwalController.text == "") {
                            alert.alertWarning(context: context, text: "Tanggal awal belum di isi");
                          } else if (TglAkhirController.text == "") {
                            alert.alertWarning(context: context, text: "Tanggal akhir belum di isi");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListReportPage(
                                    jenis_cek: _valJenisCek,
                                    jenis_kendaraan: _valJenisKendaraan,
                                    asloc: _valAsloc,
                                    kendaraan: sn,
                                    tgl_awal: TglAwalController.text,
                                    tgl_akhir: TglAkhirController.text),
                              ),
                            );
                          }
                        },
                        child: Text('OK'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showPickerTglAwal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2018), lastDate: DateTime(2101));

    setState(() {
      TglAwalController.text = '${customFormat.format(picked!)}';
    });
  }

  Future<void> showPickerTglAkhir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2018), lastDate: DateTime(2101));

    setState(() {
      TglAkhirController.text = '${customFormat.format(picked!)}';
    });
  }

  Future<void> getSloc(String usap, String psap, String werks) async {
    print("okesloc");

    var obj = await {
      'ASHOST': await preference.getData("ashost").toString(),
      'CLIENT': await preference.getData("client").toString(),
      'SYSNR': await preference.getData("sysnr").toString(),
      'USAP': await preference.getData("usap").toString(),
      'PASS': await preference.getData("pass").toString(),
      'USERID': preference.getData("id").toString(),
      'WERKS': preference.getData("werks"),
    };
    final res = await ReportService(context: context).getSloc(obj: obj);
    data = res;
    setState(() {});
  }

  Widget slocList() {
    if (data != null) {
      if (data["T_SLOC"].length != 0) {
        List<Sloc> sloclist = List<Sloc>.from(data["T_SLOC"].map((i) {
          return Sloc.fromJSON(i);
        }));
        return DropdownButton(
            hint: Text("Lokasi Aset"),
            isExpanded: true,
            value: _valAsloc,
            items: sloclist.map((sloc) {
              return DropdownMenuItem(
                value: sloc.LGORT,
                child: Text(sloc.LGOBE),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _valAsloc = value.toString();
                getLkend(usap, psap, value.toString());
              });
              print("Selected city is $value");
            });
      } else {
        return Text("Tidak ada data asloc");
      }
    } else {
      return Text("Tidak ada data asloc");
    }
  }

  Future<void> getLkend(String usap, String psap, String werks) async {
    print("getLkend");
    try {
      var obj = await {
        'ASHOST': await preference.getData("ashost").toString(),
        'CLIENT': await preference.getData("client").toString(),
        'SYSNR': await preference.getData("sysnr").toString(),
        'USAP': await preference.getData("usap").toString(),
        'PASS': await preference.getData("pass").toString(),
        'USERID': preference.getData("id").toString(),
        'WERKS': werks,
      };
      final res = await ReportService(context: context).getLkend(obj: obj);
      print(res["T_KEND"]);
      dataLkend = res;
      setState(() {});
    } catch (err) {
      alert.alertWarning(context: context, text: "Kesalahan Koneksi Ke SAP !");
    }
  }

  Widget lkendList() {
    if (dataLkend != null) {
      if (dataLkend["T_KEND"].length != 0) {
        List<Lkend> lKendList = List<Lkend>.from(dataLkend["T_KEND"].map((i) {
          return Lkend.fromJSON(i);
        }));
        return DropdownButton(
            hint: Text("Silahkan Pilih Kendaraan"),
            isExpanded: true,
            value: valKendaraan,
            items: lKendList.map((sloc) {
              return DropdownMenuItem(
                value: sloc.SERNR,
                child: Text(sloc.MAKTX),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                valKendaraan = val;
                if ("${val.toString()[0]}" == "0") {
                  sn = val.toString().substring(3);
                } else {
                  sn = val.toString();
                }
                print(sn);
              });
            });
      } else {
        return Text("Tidak ada data asloc");
      }
    } else {
      return Text("Tidak ada data asloc");
    }
  }
}

class Sloc {
  var LGORT, LGOBE;
  Sloc({this.LGORT, this.LGOBE});

  factory Sloc.fromJSON(Map<String, dynamic> json) {
    return Sloc(LGORT: json["LGORT"], LGOBE: json["LGOBE"]);
  }
}

class Lkend {
  var SERNR, MAKTX;
  Lkend({this.SERNR, this.MAKTX});

  factory Lkend.fromJSON(Map<String, dynamic> json) {
    return Lkend(SERNR: json["SERNR"], MAKTX: json["MAKTX"]);
  }
}
