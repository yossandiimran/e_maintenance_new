// ignore_for_file: constant_identifier_names, sort_child_properties_last, avoid_print, prefer_const_constructors, use_build_context_synchronously, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables
part of '../header.dart';

class ConfigSettingPage extends StatefulWidget {
  const ConfigSettingPage({Key? key}) : super(key: key);
  @override
  ConfigSettingPageState createState() => ConfigSettingPageState();
}

class ConfigSettingPageState extends State<ConfigSettingPage> {
  final addressIpController = TextEditingController();

  bool isRestart = false, checkConn = false, isConnect = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    var globalIp = await preference.getData("globalIp") ?? global.baseIp;
    var checkedIp = globalIp.split(":")[0];
    if (!checkConn) {
      setState(() => checkConn = true);
      await Socket.connect(checkedIp, 80, timeout: Duration(seconds: 5)).then((socket) {
        alert.alertSuccess(context: context, text: "IP Tersambung !");
        socket.destroy();
        setState(() => checkConn = false);
        setState(() => isConnect = true);
      }).catchError((error) {
        alert.alertWarning(context: context, text: "IP tidak tersambung, pastikan VPN aktif !");
        setState(() => checkConn = false);
        setState(() => isConnect = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Pengaturan App'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: WillPopScope(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: global.getHeight(context),
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight * 1.5 + 10),
                    GestureDetector(
                      onTap: () async {
                        var globalIp = await preference.getData("globalIp") ?? global.baseIp;
                        addressIpController.text = globalIp.toString();
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              content: SizedBox(
                                height: global.getWidth(context) / 2.5,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text("def : ${global.baseIp}", style: textStyling.customColor(12.5, defGrey)),
                                    SizedBox(height: 5),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: widget.decCont(Colors.blueGrey.shade100, 10, 10, 10, 10),
                                      child: ListTile(
                                        subtitle: TextField(
                                          controller: addressIpController,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.http_rounded),
                                            border: OutlineInputBorder(borderSide: BorderSide.none),
                                            hintText: "Host / IP",
                                          ),
                                          readOnly: false,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            await preference.setString("globalIp", addressIpController.text);
                                            Navigator.pop(context);
                                            checkConnection();
                                          },
                                          child: Container(
                                            decoration: widget.decCont2(defGreen, 8, 8, 8, 8),
                                            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                                            child: Text("Simpan", style: textStyling.customColor(14, Colors.white)),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            decoration: widget.decCont2(defRed, 8, 8, 8, 8),
                                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                            child: Text(" Cancel ", style: textStyling.customColor(14, Colors.white)),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).then((value) {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: widget.decCont(defWhite, 8, 8, 8, 8),
                        child: ListTile(
                          title: Text("Setting IP", style: textStyling.customColor(16, defBlack1)),
                          leading: Icon(Icons.http_rounded, size: 40, color: defBlack1),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defBlue),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        print(preference.getData("groupUser"));
                        if (preference.getData("groupUser").toString() != "4") {
                          isRestart = true;
                          setState(() {});
                          await RestartGlassfish(context: context, obj: {}).restartConnection();
                          print("RESTARING ....");
                          isRestart = false;
                          setState(() {});
                        } else {
                          alert.alertWarning(context: context, text: "Anda tidak memiliki akses !");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: widget.decCont(defWhite, 8, 8, 8, 8),
                        child: ListTile(
                          title: Text("Restart Koneksi", style: textStyling.customColor(16, defBlack1)),
                          leading: !isRestart
                              ? Icon(Icons.restart_alt_rounded, size: 40, color: defOrange)
                              : CircularProgressIndicator(),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defBlue),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        checkConnection();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: widget.decCont(defWhite, 8, 8, 8, 8),
                        child: ListTile(
                          title: Text("Test Koneksi", style: textStyling.customColor(16, defBlack1)),
                          leading: !checkConn
                              ? Icon(Icons.cast_connected_rounded, size: 40, color: isConnect ? defGreen : defBlue)
                              : CircularProgressIndicator(),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defBlue),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        print(preference.getData("groupUser"));
                        if (preference.getData("groupUser").toString() != "4") {
                          Navigator.pushNamed(context, '/user');
                        } else {
                          alert.alertWarning(context: context, text: "Anda tidak memiliki akses !");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: widget.decCont(defWhite, 8, 8, 8, 8),
                        child: ListTile(
                          title: Text("Setting User", style: textStyling.customColor(16, defBlack1)),
                          leading: Icon(Icons.person, size: 40, color: defBlue),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: kToolbarHeight * 1.5,
                    decoration: widget.decCont2(defBlack1, 20.0, 20.0, 0.0, 0.0),
                  ),
                ],
              ),
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
      ),
    );
  }
}
