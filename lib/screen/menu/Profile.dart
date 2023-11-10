// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables
part of "../../header.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
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
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Akun Pengguna", style: textStyling.defaultWhite(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: getBodyView(),
      ),
    );
  }

  Widget getBodyView() {
    return Stack(
      children: [
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
                padding: EdgeInsets.only(top: 20),
                height: global.getHeight(context) - (kToolbarHeight * 5.5),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(10),
                          decoration: widget.decCont2(Colors.white, 25, 25, 25, 25),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: ListTile(
                                  title: Text("Ganti Password"),
                                  leading: Icon(Icons.lock_rounded, color: defBlue),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/configSetting');
                                },
                                child: ListTile(
                                  title: Text("Pengaturan App"),
                                  leading: Icon(Icons.settings_rounded, color: defGreen),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  alert.alertLogout(context);
                                },
                                child: ListTile(
                                  title: Text("Logout"),
                                  leading: Icon(Icons.logout_rounded, color: defRed),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ),
                              Divider(thickness: 2),
                              Text("Version $appVersion", style: textStyling.nunitoBold(12, defBlack1))
                            ],
                          ),
                        ),
                      ],
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
              Container(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                height: kToolbarHeight * 3,
                decoration: widget.decorationContainerGradient(defBlack1, defBlack2, 0.0),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Column(),
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
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: widget.decCont2(defWhite, 100, 100, 100, 100),
                margin: EdgeInsets.only(top: kToolbarHeight * 1.8, bottom: 5),
                child: Icon(Icons.person, size: 40, color: defBlack1),
              ),
              Text(preference.getData("nama"), style: textStyling.defaultBlack(16))
            ],
          ),
        ),
      ],
    );
  }
}
