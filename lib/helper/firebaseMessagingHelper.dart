// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, file_names, prefer_typing_uninitialized_variables
part of '../header.dart';

class FirebaseMessagingHelper {
  final context;
  FirebaseMessagingHelper({this.context});

  initFirebase({required context}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin?.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    //Kalo App Mati
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("DATA Z 2 : " + message.data.toString());
        return Navigator.pushNamed(context, message.data["screen"]);
      }
    });

    FirebaseMessaging.onBackgroundMessage(
        (RemoteMessage? message) => Navigator.pushNamed(context, message?.data["screen"]));

    //Kalo App Lagi Run Di Dalem Background
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null && message.data.isNotEmpty) {
        print("DATA Z 3 : " + message.data.toString());
        // Navigator.pushNamed(context, message.data["screen"]);
      }
    });

    //Kalo App Lagi Run Di Luar Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        print("DATA Z 4: " + message.data.toString());
        Navigator.pushNamed(context, message.data["screen"]);
      }
    });
  }
}
