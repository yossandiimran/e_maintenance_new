// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class MainTest extends StatefulWidget {
  @override
  MainTestState createState() => MainTestState();
}

class MainTestState extends State<MainTest> {
  TextEditingController ip1 = TextEditingController();
  TextEditingController ip2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getMenuWidget(),
        bottomNavigationBar: navBarApp(),
      ),
    );
  }

  getMenuWidget() {
    switch (isMenuActive) {
      case 0:
        return getForm();
      case 1:
        return getSetting();
    }
  }

  getSetting() => SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 5),
                child: Text("  IP Utama", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: ip1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "IP Utama",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  IP Cadangan", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: ip2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "IP Cadangan",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 10),
                width: global.getWidth(context),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => getsPreference(),
                      child: Container(
                        width: global.getWidth(context) / 2.7,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.only(top: 5),
                        decoration: widget.decCont(defRed, 15, 15, 15, 15),
                        child: Row(
                          children: [
                            Spacer(),
                            Icon(Icons.arrow_back_rounded, color: defWhite),
                            Text(" Batalkan", style: textStyling.customColor(14, defWhite)),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        savePreference();
                      },
                      child: Container(
                        width: global.getWidth(context) / 2.7,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.only(top: 5),
                        decoration: widget.decCont(defGreen, 15, 15, 15, 15),
                        child: Row(
                          children: [
                            Spacer(),
                            Text("Simpan ", style: textStyling.customColor(14, defWhite)),
                            Icon(Icons.arrow_forward_rounded, color: defWhite),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  getForm() => SafeArea(
        child: Container(),
      );

  navBarApp() {
    return GNav(
        color: defGrey,
        haptic: true,
        tabBorderRadius: 20,
        curve: Curves.linear,
        duration: Duration(milliseconds: 100),
        gap: 4,
        activeColor: defWhite,
        iconSize: 24,
        backgroundColor: Colors.blueGrey.shade50,
        tabBackgroundColor: defOrange,
        tabMargin: EdgeInsets.only(left: 5, right: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onTabChange: (value) {
          isMenuActive = value;
          if (value == 1) {
            getsPreference();
          }
          setState(() {});
          print(isMenuActive);
        },
        tabs: const [
          GButton(
            icon: Icons.input,
            text: 'Form Test',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Setting IP',
          ),
        ]);
  }

  getsPreference() async {
    ip1.text = await preference.getData("ip1");
    ip2.text = await preference.getData("ip2");
    setState(() {});
  }

  savePreference() async {
    await preference.setString("ip1", ip1.text);
    await preference.setString("ip2", ip2.text);
    alert.alertSuccess(context: context, text: "Tersimpan");
  }
}

class SendServiceMain {
  final context;
  final baseIp;
  final obj;
  SendServiceMain({required this.context, required this.baseIp, required this.obj});

  Future sendService() async {
    var dataReturn;
    try {
      var url = global.getMainServiceUrl(baseIp);
      var header = {'authorization': 'Bearer ' + preference.getData('token')};
      await http.get(url, headers: header).then((res) async {
        var data = json.decode(res.body);
        if (data["success"] == 'false') {
          if (data["message" == "Unauthenticated."]) {
            global.checkResponseStatus(context: context, res: res, data: data);
          }
        }
        dataReturn = global.checkResponseStatus(context: context, res: res, data: data);
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        return global.errorResponsePop(context, "Koneksi Timeout ...");
      });
    } catch (e) {
      return global.errorResponsePop(context, "Error System Crash CTL 402");
    }
    return dataReturn;
  }
}
