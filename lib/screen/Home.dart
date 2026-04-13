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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        alert.alertConfirmExit(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: linearBg,
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(8),
      decoration: CustomWidget().linearPanelDecoration(
        radius: 24,
        color: linearPanel,
      ),
      child: GNav(
        color: linearTextTertiary,
        haptic: true,
        tabBorderRadius: 18,
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 180),
        gap: 8,
        activeColor: linearTextPrimary,
        iconSize: 22,
        backgroundColor: Colors.transparent,
        tabBackgroundColor: linearBrand.withValues(alpha: 0.18),
        tabMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        onTabChange: (value) {
          isMenuActive = value;
          setState(() {});
        },
        tabs: const [
          GButton(
            icon: Icons.dashboard_rounded,
            text: 'Workspace',
          ),
          GButton(
            icon: Icons.person_rounded,
            text: 'Akun',
          )
        ],
      ),
    );
  }
}
