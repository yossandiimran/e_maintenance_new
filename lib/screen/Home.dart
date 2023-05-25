// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member
part of '../../header.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    AuthService(context: context).getSetting();
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
        bottomNavigationBar: navBarApp(),
        body: getMenuWidget(),
      ),
    );
  }

  getMenuWidget() {
    switch (isMenuActive) {
      case 0:
        return Dashboard();
      case 1:
        return Profile();
    }
  }

  navBarApp() {
    return GNav(
        color: defWhite,
        haptic: true,
        tabBorderRadius: 15,
        curve: Curves.linear,
        duration: Duration(milliseconds: 100),
        gap: 8,
        activeColor: defWhite,
        iconSize: 24,
        backgroundColor: defBlack1,
        tabBackgroundColor: defblue2,
        tabMargin: EdgeInsets.only(left: 3, right: 3, top: 4, bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onTabChange: (value) {
          isMenuActive = value;
          setState(() {});
          print(isMenuActive);
        },
        tabs: const [
          GButton(
            icon: Icons.home_rounded,
            text: 'Home',
          ),
          GButton(
            icon: Icons.person_rounded,
            text: 'Akun',
          )
        ]);
  }
}
