import 'package:flutter/material.dart';

import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/ConfigSetting.dart';
import 'package:e_maintenance/screen/Home.dart';
import 'package:e_maintenance/screen/Login.dart';
import 'package:e_maintenance/screen/QrScanner.dart';
import 'package:e_maintenance/screen/SplashScreen.dart';
import 'package:e_maintenance/screen/cek_kendaraan/InsertPage.dart';
import 'package:e_maintenance/screen/laporan/Laporan1.dart';
import 'package:e_maintenance/screen/laporan/Laporan2.dart';
import 'package:e_maintenance/screen/laporan/ListReportPage.dart';
import 'package:e_maintenance/screen/user/User.dart';
import 'package:e_maintenance/screen/user/UserForm.dart' as user_form_screen;

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<void> splash() => _buildRoute(const SplashScreen(), 'splash');
  static Route<void> login() => _buildRoute(const Login(), 'login');
  static Route<void> home() => _buildRoute(const Home(), 'home');
  static Route<void> settings() => _buildRoute(const ConfigSettingPage(), 'settings');
  static Route<void> userManagement() => _buildRoute(const User(), 'user_management');
  static Route<void> userForm(UserFormData data) =>
      _buildRoute(user_form_screen.UserForm(initialData: data), 'user_form');
  static Route<void> transactionReportFilter() => _buildRoute(const Laporan1(), 'transaction_report_filter');
  static Route<void> userReport() => _buildRoute(const Laporan2(), 'user_report');
  static Route<void> transactionReportList(TransactionReportFilter filter) =>
      _buildRoute(ListReportPage(filter: filter), 'transaction_report_list');
  static Route<void> inspection(String barcode) => _buildRoute(InsertPage(barcode: barcode), 'inspection');
  static Route<String?> scanner() => _buildRoute(const QrScanner(), 'scanner');

  static MaterialPageRoute<T> _buildRoute<T>(Widget page, String name) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: RouteSettings(name: name),
    );
  }

  static Future<void> replaceWithLogin(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(login(), (route) => false);
  }

  static Future<void> replaceWithHome(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(home(), (route) => false);
  }

  static void handleNotificationPayload(Map<String, dynamic> payload) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    switch ('${payload['screen'] ?? ''}') {
      case '/home':
        navigator.push(home());
        break;
      case '/lap1':
        navigator.push(transactionReportFilter());
        break;
      case '/lap2':
        navigator.push(userReport());
        break;
      case '/user':
        navigator.push(userManagement());
        break;
      case '/configSetting':
        navigator.push(settings());
        break;
      default:
        break;
    }
  }
}
