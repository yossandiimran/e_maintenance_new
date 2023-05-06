import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:http/http.dart' as http;
import 'package:e_maintenance/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Helper /  Styling / Widget Custom
part 'helper/firebaseMessagingHelper.dart';
part 'helper/preference.dart';
part 'widget/Alert.dart';
part 'widget/CustomWidget.dart';
part 'widget/TextStyling.dart';

// Model ======================================

// Service ======================================
part 'service/AuthService.dart';

// Screen / View ======================================
part 'screen/Login.dart';
part 'screen/SplashScreen.dart';
part 'screen/Home.dart';
part 'screen/Dashboard.dart';
part 'screen/menu/Profile.dart';
// ================= Vendor Screen ====================

//Testing Menu
part 'screen/testMenu/mainTest.dart';
