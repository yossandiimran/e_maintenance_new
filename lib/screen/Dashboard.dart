// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List listPengajuan = ["pengajuan1"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        alert.alertConfirmExit(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: defWhite,
        extendBodyBehindAppBar: true,
        appBar: widget.appBarTitle(context, "E-Maintenance New", Colors.transparent),
        body: Stack(children: [
          widget.bgAppbar(context),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  height: global.getHeight(context) - (kToolbarHeight * 2.5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    color: defBlack1,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: global.getWidth(context),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              "Selamat datang, \n" + preference.getData("nama"),
                              style: textStyling.customColor(global.getWidth(context) / 20, defWhite),
                            ),
                            Spacer(),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert_rounded, color: defWhite),
                              onSelected: (value) async {
                                if (value == "Logout") {
                                  alert.alertLogout(context);
                                } else {
                                  var token = await FirebaseMessaging.instance.getToken();
                                  print(token);
                                }
                              },
                              itemBuilder: (BuildContext context) => widget.getChoicePopUp(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: 4,
                  decoration: BoxDecoration(
                    color: defGreen,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: kToolbarHeight * 2.6),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                leading: Icon(Icons.dashboard_rounded, color: defblue2, size: 40),
                                title: Text(
                                  "Menu :",
                                  style: textStyling.defaultBlackBold(20),
                                ),
                              ),
                              SizedBox(height: 7),
                              Divider(color: defBlack1, thickness: 4),
                              SizedBox(height: 14),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      openQrPage();
                                    },
                                    child: Container(
                                      width: global.getWidth(context) / 1.2,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                      decoration: widget.decCont2(defWhite, 19, 19, 19, 19),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/barcode.png", width: 60),
                                          Spacer(),
                                          Text(
                                            "Cek kendaraan",
                                            style: textStyling.customColorBold(16, defBlack1),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      var ijs = preference.getData("id_jenis_user");
                                      if (ijs != "4") {
                                        Navigator.pushNamed(context, '/lap1');
                                      } else {
                                        alert.alertWarning(context: context, text: "Anda tidak memiliki akses");
                                      }
                                    },
                                    child: Container(
                                      width: global.getWidth(context) / 1.2,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                      decoration: widget.decCont2(defPurple, 19, 19, 19, 19),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/printer.png", width: 60),
                                          Spacer(),
                                          Text(
                                            "Laporan Transaksi",
                                            style: textStyling.customColorBold(16, defWhite),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      var ijs = preference.getData("id_jenis_user");
                                      if (ijs != "4") {
                                        Navigator.pushNamed(context, '/lap2');
                                      } else {
                                        alert.alertWarning(context: context, text: "Anda tidak memiliki akses");
                                      }
                                    },
                                    child: Container(
                                      width: global.getWidth(context) / 1.2,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                      decoration: widget.decCont2(defOrange, 19, 19, 19, 19),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/maintenance_planning.png", width: 60),
                                          Spacer(),
                                          Text(
                                            "Laporan User",
                                            style: textStyling.customColorBold(16, defWhite),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      var ijs = preference.getData("id_jenis_user");
                                      if (ijs != "4") {
                                        Navigator.pushNamed(context, '/user');
                                      } else {
                                        alert.alertWarning(context: context, text: "Anda tidak memiliki akses");
                                      }
                                    },
                                    child: Container(
                                      width: global.getWidth(context) / 1.2,
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                      decoration: widget.decCont2(defGreen, 19, 19, 19, 19),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png",
                                            width: 60,
                                          ),
                                          Spacer(),
                                          Text(
                                            "Setting User",
                                            style: textStyling.customColorBold(16, defWhite),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  openQrPage() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: global.getHeight(context),
        color: Colors.white,
        child: QrScanner(),
      ),
    ).then((value) async {
      qrCode = "1C001C03TEST0001";
      // qrCode = "1C001C03TEST0004";

      if (qrCode != "-") {
        Navigator.pushNamed(context, '/insert', arguments: {"qrCode": qrCode});
      }
      setState(() {});
    });
  }
}
