// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, await_only_futures
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
  String _valAsloc = "";
  String _valKendaraan = "";
  String sn = "";
  DateTime selectedDate = DateTime.now();
  var customFormat = DateFormat('yyyy-MM-dd');

  final List _listJenisCek = ["1", "2", "3"];
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        title: Text("Laporan", style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
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
                          child: Text((value == "1" ? "Harian" : (value == "2" ? "Mingguan" : "Bulanan"))),
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
                          // if (_valJenisCek == null) {
                          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          //     content: Text("Jenis cek belum di pilih"),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          // } else if (_valJenisKendaraan == null) {
                          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          //     content: Text("Jenis kendaraan belum di pilih"),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          // } else if (TglAwalController.text == "") {
                          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          //     content: Text("Tanggal awal belum di isi"),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          // } else if (TglAkhirController.text == "") {
                          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          //     content: Text("Tanggal akhir belum di isi"),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          // } else {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ListLaporan1(
                          //         jenis_cek: _valJenisCek,
                          //         jenis_kendaraan: _valJenisKendaraan,
                          //         asloc: _valAsloc,
                          //         kendaraan: sn,
                          //         tgl_awal: TglAwalController.text,
                          //         tgl_akhir: TglAkhirController.text),
                          //   ),
                          // );
                          // }
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

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        TglAwalController.text = '${customFormat.format(selectedDate)}';
      });
    }
  }

  Future<void> showPickerTglAkhir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2018), lastDate: DateTime(2101));

    if (picked != selectedDate)
      setState(() {
        selectedDate = picked!;
        TglAkhirController.text = '${customFormat.format(selectedDate)}';
      });
  }

  Future<void> getSloc(String usap, String psap, String werks) async {
    print("okesloc");

    var obj = await {
      'ashost': await preference.getData("ashost"),
      'client': await preference.getData("client"),
      'sysnr': await preference.getData("sysnr"),
      'usap': usap,
      'psap': psap
    };
    final res = await ReportService(context: context).getSloc(obj: obj);
    data = res;
    setState(() {});
    print(res);
    print(data);

    //attache countryname on parameter country in url
    // if (res.statusCode == 200) {
    //   setState(() {
    //     data = json.decode(res.body);
    //   });
    //   print(data);
    // } else {
    //   //there is error
    //   setState(() {
    //     error = true;
    //     message = "Error during fetching data";
    //   });
    // }
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
                _valKendaraan = "";
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await http.post(
      Uri.parse("http://192.168.1.128:7171/emaintenance/getlkend"),
      body: {
        'werks': werks,
        'ashost': preferences.getString("ashost"),
        'client': preferences.getString("client"),
        'sysnr': preferences.getString("sysnr"),
        'usap': usap,
        'psap': psap
      },
    );
    //attache countryname on parameter country in url
    if (res.statusCode == 200) {
      setState(() {
        dataLkend = json.decode(res.body);
        // print(dataLkend);
      });
    } else {
      //there is error
      setState(() {
        error = true;
        message = "Error during fetching data";
      });
    }
  }

  Widget lkendList() {
    //widget function for city list
    if (dataLkend != null) {
      if (dataLkend["result"]["T_KEND"].length != 0) {
        List<Lkend> Lkendlist = List<Lkend>.from(dataLkend["result"]["T_KEND"].map((i) {
          return Lkend.fromJSON(i);
        })); //searilize sloclist json data to object model.
        return DropdownButton(
            hint: Text("Pilih Aset"),
            isExpanded: true,
            value: _valKendaraan,
            items: Lkendlist.map((lkend) {
              return DropdownMenuItem(
                value: lkend.SERNR,
                child: Text(lkend.MAKTX),
              );
            }).toList(),
            onChanged: (value) {
              // setState(() {
              //   _valKendaraan = value.toString();
              //   if ("${value[0]}" == "0") {
              //     sn = value.substring(3);
              //     print("Awalan 000 : ");
              //     print(sn);
              //   } else {
              //     sn = value;
              //   }
              // });
              // print("Huruf awal ${_valKendaraan[0]}");
              // print("Huruf terakhir ${_valKendaraan[17]}");
              // print("Selected city is $_valKendaraan");
            });
      } else {
        return Text("Tidak ada data kendaraan");
      }
    } else {
      return Text("Tidak ada data kendaraan");
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
