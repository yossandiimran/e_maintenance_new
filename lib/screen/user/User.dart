// ignore_for_file: file_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, no_logic_in_create_state, invalid_use_of_visible_for_testing_member, avoid_print, prefer_interpolation_to_compose_strings, use_build_context_synchronously
part of "../../header.dart";

class User extends StatefulWidget {
  final barcode;
  User({Key? key, this.barcode = ''}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool loading = true;
  bool edit = false;
  List data = [];

  TextEditingController namaController = TextEditingController();
  TextEditingController werksController = TextEditingController();
  String jenisUser = "0";
  String activeId = "0";

  @override
  void initState() {
    super.initState();
    getListUser();
  }

  Future<void> getListUser() async {
    Map obj = {"lokasi": preference.getData("werks")};
    data = await UserService(context: context, objParam: obj).getUserList();
    data.sort((a, b) => a["name"].compareTo(b["name"]));
    if (data.isNotEmpty) {
      loading = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 0,
        title: Text("Setting User"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              loading = true;
              setState(() {});
              Map obj = {
                "jenis": "Tambah",
              };
              Navigator.pushNamed(context, '/userForm', arguments: obj).then((value) => getListUser());
            },
            icon: Icon(Icons.add_rounded),
          ),
        ],
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(width: 1),
                          ),
                          columnWidths: {
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(50),
                            2: FixedColumnWidth(50.0),
                            3: FixedColumnWidth(50.0),
                          },
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  decoration: widget.decCont(defBlue, 0, 0, 10, 0),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Username",
                                    textAlign: TextAlign.center,
                                    style: textStyling.defaultWhiteBold(14),
                                  ),
                                ),
                                Container(
                                  decoration: widget.decCont(defBlue, 0, 0, 0, 0),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Lokasi",
                                    textAlign: TextAlign.center,
                                    style: textStyling.defaultWhiteBold(14),
                                  ),
                                ),
                                Container(
                                  decoration: widget.decCont(defBlue, 0, 0, 0, 0),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Edit",
                                    textAlign: TextAlign.center,
                                    style: textStyling.defaultWhiteBold(14),
                                  ),
                                ),
                                Container(
                                  decoration: widget.decCont(defBlue, 0, 0, 0, 10),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Hapus",
                                    textAlign: TextAlign.center,
                                    style: textStyling.defaultWhiteBold(14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: widget.decCont2(defWhite, 10, 10, 0, 0),
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        height: global.getHeight(context) - (kToolbarHeight * 2),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Table(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(width: 1),
                                ),
                                columnWidths: {
                                  0: FlexColumnWidth(),
                                  1: FixedColumnWidth(50),
                                  2: FixedColumnWidth(50.0),
                                  3: FixedColumnWidth(50.0),
                                },
                                children: [for (var i = 0; i < data.length; i++) getDataDetail(i, data[i])],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  openModalSheet(jenis) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: global.getHeight(context) / 2.5,
          padding: MediaQuery.of(context).viewInsets,
          decoration: widget.decCont(defWhite, 0, 0, 20, 20),
          child: Column(
            children: [
              SizedBox(height: 5),
              Text("Form $jenis User", style: textStyling.defaultBlackBold(18)),
              Divider(thickness: 2),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: widget.decCont(Colors.white, 23, 23, 23, 23),
                child: TextField(
                  inputFormatters: [LowerCaseTextFormatter()],
                  controller: namaController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: defBlue),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Nama",
                  ),
                  readOnly: false,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  inputFormatters: [UpperCaseTextFormatter()],
                  controller: werksController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_city_rounded, color: defPurple),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Werks",
                  ),
                  readOnly: false,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 0),
                child: ListTile(
                  subtitle: DropdownButton<String>(
                    value: jenisUser,
                    isExpanded: true,
                    items: getItemsDropdown(),
                    onChanged: (newValue) {
                      jenisUser = newValue!;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Text(
                "Password : centr@l1001",
                style: TextStyle(fontStyle: FontStyle.italic, color: defBlue),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      alert.loadingAlert(context: context, text: "Menyimpan Data", isPop: true);
                      Map obj = {
                        "username": namaController.text,
                        "werks": werksController.text,
                        "id_jenis_user": jenisUser,
                        "id": activeId,
                      };
                      if (namaController.text == "" || werksController.text == "" || jenisUser == "0") {
                        return global.errorResponse(context, "Silahkan Lengkapi Data !");
                      }
                      String send = await UserService(context: context, objParam: obj).addUserList();
                      if (send == "Sukses") {
                        global.successResponsePop(context, "Data berhasil disimpan !");
                        namaController.text = "";
                        werksController.text = "";
                        jenisUser = "0";
                        activeId = "0";
                      } else {
                        global.errorResponsePop(context, send);
                      }
                      getListUser();
                    },
                    child: Container(
                      width: 80,
                      decoration: widget.decCont2(defGreen, 10, 10, 10, 10),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(edit ? "Edit" : "Simpan", style: textStyling.defaultWhiteBold(14)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      namaController.text = "";
                      werksController.text = "";
                      jenisUser = "0";
                      activeId = "0";
                      edit = false;
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Container(
                      width: 80,
                      decoration: widget.decCont2(defRed, 10, 10, 10, 10),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text("Batal", style: textStyling.defaultWhiteBold(14)),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getItemsDropdown() {
    List<DropdownMenuItem<String>> widget = [];
    widget.add(DropdownMenuItem(value: "0", child: Text("Pilih Jenis User", style: textStyling.defaultBlack(14))));
    widget.add(DropdownMenuItem(value: "1", child: Text("Admin", style: textStyling.defaultBlack(14))));
    widget.add(DropdownMenuItem(value: "2", child: Text("Pimpinan", style: textStyling.defaultBlack(14))));
    widget.add(DropdownMenuItem(value: "3", child: Text("Kabag", style: textStyling.defaultBlack(14))));
    widget.add(DropdownMenuItem(value: "4", child: Text("User", style: textStyling.defaultBlack(14))));
    return widget;
  }

  getDataDetail(i, val) {
    return TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            (val["username"]).toString(),
            textAlign: TextAlign.start,
            style: textStyling.defaultBlackBold(12),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            (val["werks"]).toString(),
            textAlign: TextAlign.start,
            style: textStyling.defaultBlackBold(12),
          ),
        ),
        GestureDetector(
          onTap: () {
            Map obj = {
              "jenis": "Edit",
              "nama": val["name"],
              "werks": val["werks"],
              "jenisUser": val["id_jenis_user"],
              "id": val["id"],
            };
            Navigator.pushNamed(context, '/userForm', arguments: obj).then((value) => getListUser());
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.edit_rounded, color: defOrange),
          ),
        ),
        GestureDetector(
          onTap: () async {
            alert.loadingAlert(context: context, text: "Menghapus Data ... ", isPop: false);
            Map obj = {
              "id": val["id"].toString(),
            };
            var resp = await UserService(context: context, objParam: obj).deleteUserList();
            if (resp == "Sukses") {
              global.successResponsePop(context, "Berhasil Menghapus Data");
            } else {
              global.errorResponsePop(context, "Kesalahan Service !");
            }
            getListUser();
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.delete_rounded, color: defRed),
          ),
        ),
      ],
    );
  }
}
