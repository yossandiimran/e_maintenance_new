// ignore_for_file: file_names, prefer_const_constructors, avoid_print

part of '../header.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSplashScreen();
    fbmessaging.initFirebase(context: context);
  }

  checkSplashScreen() async {
    try {
      await preference.initialization();
      var name = await preference.getData("id");
      if (name != null) {
        if (mounted) Navigator.pushNamed(context, "/home");
      } else {
        if (mounted) Navigator.pushNamed(context, "/login");
      }
    } catch (err) {
      // print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        alert.alertConfirmExit(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.blueGrey.shade50,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: SizedBox(
                height: global.getHeight(context),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      "E - Maintenance \n",
                      textAlign: TextAlign.center,
                      style: textStyling.customColorBold(30, defBlack2),
                    ),
                    Image.asset(
                      "assets/icon.png",
                      width: global.getWidth(context) / 2,
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "\n\"Selamat datang di aplikasi pengecekan rutin Kendaraan Central Springbed\"",
                        textAlign: TextAlign.center,
                        style: textStyling.customColor(16, defBlack1),
                      ),
                    ),
                    SizedBox(height: 40),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        width: global.getWidth(context),
                        height: kToolbarHeight,
                        decoration: widget.decCont2(defBlack1, 0, 0, 30, 30),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              "Mulai Sekarang",
                              style: textStyling.defaultWhiteBold(14),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
