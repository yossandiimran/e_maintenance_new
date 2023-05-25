// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:e_maintenance/model/TodoModels.dart';
import 'package:excel/excel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zebra_sdk/flutter_zebra_sdk.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:e_maintenance/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zebrautility/ZebraPrinter.dart';
// import 'package:zebrautility/zebrautility.dart';

// Helper /  Styling / Widget Custom
part 'helper/firebaseMessagingHelper.dart';
part 'helper/preference.dart';
part 'widget/Alert.dart';
part 'widget/CustomWidget.dart';
part 'widget/TextStyling.dart';

// Model ======================================

// Service ======================================
part 'service/AuthService.dart';
part 'service/InputService.dart';
part 'service/ReportService.dart';
part 'service/UserService.dart';

// Screen / View ======================================
part 'screen/TestBtPrinter.dart';
part 'screen/Login.dart';
part 'screen/SplashScreen.dart';
part 'screen/QrScanner.dart';
part 'screen/Home.dart';
part 'screen/Dashboard.dart';
part 'screen/menu/Profile.dart';
part 'screen/cek_kendaraan/InsertPage.dart';
part 'screen/laporan/Laporan1.dart';
part 'screen/laporan/Laporan2.dart';
part 'screen/laporan/excel/ExcelReportUse.dart';
part 'screen/user/User.dart';
// ================= Vendor Screen ====================
