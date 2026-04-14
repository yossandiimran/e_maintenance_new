// File generated manually based on google-services.json.
// To regenerate, run: flutterfire configure
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return android; // fallback
      case TargetPlatform.linux:
        return android; // fallback
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ──────────────────────────────────────────────
  //  WEB  –  Register a Web app in Firebase Console
  //          (Project Settings → General → Add app → Web)
  //          then replace the values below.
  // ──────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvtfyVWHC5ukTXACmfYj0_7lQQPqXYdyo',
    appId: '1:743489091314:web:REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '743489091314',
    projectId: 'master-data-graha',
    authDomain: 'master-data-graha.firebaseapp.com',
    storageBucket: 'master-data-graha.appspot.com',
  );

  // ──────────────────────────────────────────────
  //  ANDROID  –  from google-services.json
  // ──────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvtfyVWHC5ukTXACmfYj0_7lQQPqXYdyo',
    appId: '1:743489091314:android:14396ebd8bf346e556026b',
    messagingSenderId: '743489091314',
    projectId: 'master-data-graha',
    storageBucket: 'master-data-graha.appspot.com',
  );

  // ──────────────────────────────────────────────
  //  iOS / macOS  –  add from GoogleService-Info.plist
  //                   if you have one; otherwise keep
  //                   same as Android as placeholder.
  // ──────────────────────────────────────────────
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvtfyVWHC5ukTXACmfYj0_7lQQPqXYdyo',
    appId: '1:743489091314:android:14396ebd8bf346e556026b',
    messagingSenderId: '743489091314',
    projectId: 'master-data-graha',
    storageBucket: 'master-data-graha.appspot.com',
    iosBundleId: 'com.central.maintenanceV2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvtfyVWHC5ukTXACmfYj0_7lQQPqXYdyo',
    appId: '1:743489091314:android:14396ebd8bf346e556026b',
    messagingSenderId: '743489091314',
    projectId: 'master-data-graha',
    storageBucket: 'master-data-graha.appspot.com',
    iosBundleId: 'com.central.maintenanceV2',
  );
}
