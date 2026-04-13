// ignore_for_file: file_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, no_logic_in_create_state, invalid_use_of_visible_for_testing_member, avoid_print
part of "../../header.dart";

class InsertPage extends StatefulWidget {
  final barcode;
  InsertPage({Key? key, this.barcode = ''}) : super(key: key);

  @override
  _InsertPageState createState() => _InsertPageState(barcode);
}

class _InsertPageState extends State<InsertPage> {
  final String barcode;
  _InsertPageState(this.barcode);
  bool indikatorKondisi = false;
  bool loading = true;
  late File _image;
  String fileName = "";
  List data = [];
  String FLAG = "", MAKTX = "", MATNR = "", MSG = "", sn = "";
  String username = "", nama = "", usap = "", psap = "", werks = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textKeteranganController = TextEditingController();

  final name = TextEditingController();
  final desc = TextEditingController();
  final jenis_todo = TextEditingController();
  final nrp_pengemudi = TextEditingController();
  final nama_pengemudi = TextEditingController();
  final kendaraan = TextEditingController();
  final TodoBloc bloc = TodoBloc();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String tglSekarang = formatter.format(now);
  int _valJP = 0;
  final client = http.Client();
  DateTime _date = DateTime.now();

  getTodo(String jeniscek, String urls) async {
    Map obj = {"jenisCek": jeniscek};
    var response = await InputService(context: context, objParam: obj).getTodoList(urls: urls);
    data = json.decode(response);
    indikatorKondisi = false;
    setState(() {});
  }

  Future<String> getDataKendaraan() async {
    print("Tahap 1");
    var resp;
    try {
      Map obj = {
        'SERNR': barcode.toString(),
        'WERKS': preference.getData("werks").toString(),
        'ASHOST': preference.getData("ashost").toString(),
        'CLIENT': preference.getData("client").toString(),
        'SYSNR': preference.getData("sysnr").toString(),
        'USAP': preference.getData("usap").toString(),
        'PASS': preference.getData("pass").toString(),
        'USERID': preference.getData("id").toString(),
      };
      print(obj);
      var response = await InputService(context: context, objParam: obj).getDataKendaraan();
      loading = false;
      resp = jsonDecode(response);
      MAKTX = resp['MAKTX'];
      FLAG = resp['FLAG'];
      MATNR = resp['MATNR'];
      MSG = resp['MSG'];
      sn = barcode.substring(barcode.length - 5);
      if (!mounted) return "Success!";
      setState(() {});
      return "Success!";
    } catch (err) {
      print(err);
      if (!mounted) return "failed";
      global.errorResponsePop(
        context,
        resp,
      );
      return "failed";
    }
  }

  getCekKondisi(String jeniscek) {
    setState(() {
      if (MSG ==
          "Data Tidak Ditemukan                                                                                                                ") {
        showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Peringatan!'),
            content: const Text('Data Tidak Ditemukan! Mungkin barcode serial number salah/bukan serial number.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  Navigator.popAndPushNamed(context, '/');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (MSG == "RFC_LOGON_FAILURE::USER ATAU KATA SANDI SALAH..!!!") {
        showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Peringatan!'),
            content: const Text('USER ATAU KATA SANDI SALAH..!!!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (FLAG == "X") {
          getTodo(jeniscek, "getDataTodoForklip");
        } else if (FLAG == "") {
          getTodo(jeniscek, "getDataTodoMobil");
        } else {
          Navigator.pop(context);
          showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Peringatan!'),
              content: const Text('KONEKSI SAP TIMEOUT, HARAP RESTART KONEKSI SAP MELALUI MENU SETTING APLIKASI !'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  getPref() async {
    setState(() {
      username = preference.getData("username");
      nama = preference.getData("nama");
      usap = preference.getData("usap");
      psap = preference.getData("psap");
      werks = preference.getData("werks");
    });
    getDataKendaraan();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    final ui = CustomWidget();
    return Scaffold(
      backgroundColor: linearBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: linearBg,
        title: Text("Tambah Pengecekan", style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true)),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: linearTextPrimary, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_rounded, color: linearAccent),
            onPressed: () {
              print(_valJP);
              try {
                if (_valJP != 0) {
                  alert.loadingAlert(context: context, text: "Menimpan Data", isPop: false);
                  String date = "${_date.year}-${_date.month}-${_date.day}";
                  bloc.addTodo(
                      context, data, data[0]["jenis_cek"], date, _valJP.toString(), barcode, MAKTX, nama, werks);
                } else {
                  alert.alertWarning(context: context, text: "Jenis Pengecekan Belum Dipilih !");
                }
              } catch (err) {
                alert.alertWarning(context: context, text: "Terjadi Kesalahan Sistem !");
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(gradient: global.heroGradient),
              height: kToolbarHeight * 6,
            ),
          ),
          loading == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: linearAccent,
                    ),
                  ),
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(15),
                        decoration: ui.linearPanelDecoration(radius: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: linearTextSecondary,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'NRP/Nama : '),
                                  TextSpan(
                                    text: nama,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: linearTextPrimary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: linearTextSecondary,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Lokasi : '),
                                  TextSpan(
                                    text: werks,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: linearTextPrimary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: linearTextSecondary,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Kendaraan : '),
                                  TextSpan(
                                    text: MAKTX,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: linearTextPrimary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: linearTextSecondary,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Serial No : '),
                                  TextSpan(
                                    text: sn,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: linearTextPrimary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: linearTextSecondary,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Tanggal : '),
                                  TextSpan(
                                    text: global.convertDate(tglSekarang).toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold, color: linearTextPrimary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: ui.linearPanelDecoration(radius: 24),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(
                              "\nJenis Pengecekan:",
                              style: textStyling.linearTitle(16, color: linearTextPrimary, strong: true),
                            ),
                            RadioGroup<int>(
                              groupValue: _valJP,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _valJP = value;
                                  indikatorKondisi = true;
                                  getCekKondisi(value.toString());
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio(value: 1, activeColor: linearAccent),
                                  Text("Harian", style: textStyling.linearCaption(11, color: linearTextSecondary)),
                                  Radio(value: 2, activeColor: linearAccent),
                                  Text("Mingguan", style: textStyling.linearCaption(11, color: linearTextSecondary)),
                                  Radio(value: 3, activeColor: linearAccent),
                                  Text("Bulanan", style: textStyling.linearCaption(11, color: linearTextSecondary)),
                                  Radio(value: 4, activeColor: linearAccent),
                                  Text("Tutup Pabrik", style: textStyling.linearCaption(11, color: linearTextSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Daftar pengecekan",
                          style: textStyling.linearTitle(16, color: linearTextPrimary, strong: true),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: indikatorKondisi,
                                child: CircularProgressIndicator(color: linearAccent),
                              ),
                            ],
                          ),
                          data == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '"Silahkan pilih jenis pengecekan."',
                                      style: textStyling.linearBody(14, color: linearTextTertiary),
                                    ),
                                  ],
                                )
                              : data.isNotEmpty
                                  ? SizedBox(
                                      height: global.getHeight(context) / 1.98,
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        controller: ScrollController(),
                                        child: Column(
                                          children: [
                                            for (var index = 0; index < data.length; index++)
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                decoration: ui.linearCardDecoration(
                                                  radius: 20,
                                                  color: data[index]["_is_done"]
                                                      ? linearSuccess.withValues(alpha: 0.16)
                                                      : linearAccent.withValues(alpha: 0.12),
                                                ),
                                                child: Column(
                                                  children: [
                                                    CheckboxListTile(
                                                      value: data[index]["_is_done"],
                                                      title: Text(
                                                        data[index]["title"],
                                                        style: textStyling.linearBody(14, color: linearTextPrimary, emphasis: true),
                                                      ),
                                                      onChanged: (Value) {
                                                        setState(() {
                                                          if (data[index]["_is_done"] != true) {
                                                            _imgFromCamera(index);
                                                          } else {
                                                            _imgFromCamera(index);
                                                          }
                                                        });
                                                      },
                                                      dense: false,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Belum ada daftar pengecekan !.",
                                          style: textStyling.linearBody(13, color: linearTextTertiary),
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _imgFromCamera(int index) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1392.00,
      maxHeight: 1856.00,
      imageQuality: 30,
    );
    if (!mounted || image == null) return;

    setState(() {
      _textKeteranganController.text = "";
      _image = File(image.path);
      data[index]["_is_done"] = true;
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        scrollable: true,
        title: const Text('Photo dan Keterangan'),
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _image == null ? Text('No image selected.') : Image.file(_image),
                TextFormField(
                  controller: _textKeteranganController,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter any text";
                  },
                  decoration: InputDecoration(hintText: "Isi keterangan"),
                ),
              ],
            )),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context, 'Upload Photo');
                setState(() {
                  data[index]["_is_done"] = false;
                });
              },
              child: const Text("Ulangi")),
          TextButton(
            onPressed: () {
              fileName = (_image != null ? _image.path.split('/').last : "");
              if (_textKeteranganController.text == "") {
                final snackBar = SnackBar(
                  content: Text('Keterangan belum di isi!.'),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (fileName.toString() == "") {
                final snackBar = SnackBar(
                  content: Text('Photo belum di isi!.'),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pop(context, 'Upload Photo');
                setState(() {
                  data[index]["keterangan"] = _textKeteranganController.text;
                  data[index]["photo"] = fileName.toString();
                });
                _uploadFile(_image);
              }
            },
            child: const Text('Upload Photo'),
          ),
        ],
      ),
    );
  }

  _uploadFile(File file) async {
    print(file);
    InputService(context: context).uploadFoto(image: file);
  }
}
