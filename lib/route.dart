// ignore_for_file: prefer_const_constructors
part of 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var enc = jsonEncode(settings.arguments);
    var dec = jsonDecode(enc);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      // return MaterialPageRoute(builder: (_) => TestBtPrinter());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/lap1':
        return MaterialPageRoute(builder: (_) => Laporan1());
      case '/lap2':
        return MaterialPageRoute(builder: (_) => Laporan2());
      case '/user':
        return MaterialPageRoute(builder: (_) => User());
      case '/userForm':
        return MaterialPageRoute(builder: (_) => UserForm(obj: settings.arguments));
      case '/insert':
        return MaterialPageRoute(builder: (_) => InsertPage(barcode: dec["qrCode"]));
      case '/configSetting':
        return MaterialPageRoute(builder: (_) => ConfigSettingPage());
      case '/testBtPrinter':
        return MaterialPageRoute(builder: (_) => TestBtPrinter());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('Error page')),
      );
    });
  }
}
