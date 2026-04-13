// ignore_for_file: use_key_in_widget_constructors, avoid_print, unused_element
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:e_maintenance/header.dart';

part "route.dart";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageBg = Color(0xFF08090A);
    const panelBg = Color(0xFF0F1011);
    const surfaceBg = Color(0xFF191A1B);
    const brand = Color(0xFF5E6AD2);
    const accent = Color(0xFF7170FF);
    const textPrimary = Color(0xFFF7F8F8);
    const textSecondary = Color(0xFF8A8F98);
    final borderSubtle = Colors.white.withValues(alpha: 0.05);
    final borderStandard = Colors.white.withValues(alpha: 0.08);
    return MaterialApp(
      title: "eMaintenance V2",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: pageBg,
        fontFamily: 'Lato',
        colorScheme: const ColorScheme.dark(
          primary: brand,
          secondary: accent,
          surface: panelBg,
          onPrimary: textPrimary,
          onSecondary: textPrimary,
          onSurface: textPrimary,
        ),
        dividerColor: borderSubtle,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textPrimary),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.24,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.02),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: borderStandard),
          ),
          margin: EdgeInsets.zero,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: panelBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: borderStandard),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceBg,
          contentTextStyle: const TextStyle(
            color: textPrimary,
            fontFamily: 'Lato',
            fontSize: 14,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderStandard),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: panelBg,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            side: BorderSide(color: borderStandard),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.02),
          labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
          hintStyle: const TextStyle(color: textSecondary, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: accent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: borderSubtle),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: textPrimary,
            fontFamily: 'Nunito',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 1.05,
            letterSpacing: -1.05,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontFamily: 'Nunito',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -0.7,
          ),
          titleLarge: TextStyle(
            color: textPrimary,
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.24,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: textPrimary,
            fontFamily: 'Lato',
            fontSize: 16,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            color: textPrimary,
            fontFamily: 'Lato',
            fontSize: 14,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            color: textPrimary,
            fontFamily: 'Lato',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(
            color: textSecondary,
            fontFamily: 'Lato',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: panelBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderStandard),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
