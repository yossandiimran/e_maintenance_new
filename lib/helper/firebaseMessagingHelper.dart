import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:e_maintenance/core/logging/app_logger.dart';
import 'package:e_maintenance/firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.debug('Handled background push message', message.messageId ?? 'unknown');
}

class FirebaseMessagingHelper {
  FirebaseMessagingHelper({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _notificationsPlugin = notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  AndroidNotificationChannel? _channel;

  Future<void> initialize({
    required void Function(Map<String, dynamic> payload) onPayloadOpen,
  }) async {
    // On web, Firebase Messaging requires a valid web appId and a registered
    // service worker. Wrap everything so a misconfigured web build never
    // prevents the rest of the app from starting.
    if (kIsWeb) {
      try {
        FirebaseMessaging.onMessage.listen((message) {
          AppLogger.debug('Web foreground push', message.data);
        });

        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          AppLogger.debug('Push tapped from background (web)', message.data);
          onPayloadOpen(message.data);
        });
      } catch (e) {
        AppLogger.error('Firebase Messaging init skipped on web', e);
      }
      return;
    }

    // ── Native (Android / iOS) path ──
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _channel = const AndroidNotificationChannel(
      'e_maintenance_alerts',
      'E-Maintenance Alerts',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel!);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification == null || android == null || _channel == null) {
        return;
      }

      await _notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel!.id,
            _channel!.name,
            icon: 'launcher_icon',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      AppLogger.debug('Push tapped from background', message.data);
      onPayloadOpen(message.data);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.debug('Push opened app from terminated state', initialMessage.data);
      onPayloadOpen(initialMessage.data);
    }
  }

  Future<String?> getDeviceToken() async {
    try {
      if (kIsWeb) {
        // On web, token retrieval may fail if service worker is not registered.
        // Return null gracefully so login continues without push support.
        try {
          return await FirebaseMessaging.instance.getToken(
            vapidKey: null, // set your VAPID key here if you have one
          );
        } catch (e) {
          AppLogger.error('Web push token not available (service worker may not be ready)', e);
          return null;
        }
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (error) {
      AppLogger.error('Failed to read Firebase device token', error);
      return null;
    }
  }
}
