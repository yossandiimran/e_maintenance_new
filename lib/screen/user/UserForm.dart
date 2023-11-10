// ignore_for_file: file_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, no_logic_in_create_state, invalid_use_of_visible_for_testing_member, avoid_print, prefer_interpolation_to_compose_strings, use_build_context_synchronously
part of "../../header.dart";

class UserForm extends StatefulWidget {
  final obj;
  UserForm({Key? key, this.obj}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState(obj);
}

class _UserFormState extends State<UserForm> {
  bool loading = true;
  bool edit = false;
  List data = [];

  TextEditingController namaController = TextEditingController();
  TextEditingController werksController = TextEditingController();
  String jenisUser = "0";
  String activeId = "0";
  final obj;
  _UserFormState(this.obj);

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() {
    if (obj["jenis"] == "Edit") {
      setState(() {
        namaController.text = obj["nama"];
        werksController.text = obj["werks"];
        jenisUser = obj["jenisUser"];
        activeId = obj["id"].toString();
        edit = true;
      });
    }
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
            onPressed: () {},
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
          SizedBox(
            height: global.getHeight(context),
            child: Column(
              children: [
                Container(
                  height: global.getHeight(context) / 2.5,
                  decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text("Form " + obj["jenis"] + " User", style: textStyling.defaultBlackBold(18)),
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
                            hintText: "Lokasi",
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
                                Navigator.pop(context);
                                global.successResponsePop(context, "Data berhasil disimpan !");
                                namaController.text = "";
                                werksController.text = "";
                                jenisUser = "0";
                                activeId = "0";
                              } else {
                                global.errorResponsePop(context, send);
                              }
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
              ],
            ),
          ),
        ],
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
}
