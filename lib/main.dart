import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/firebaseMessagingHelper.dart';
import 'package:e_maintenance/helper/preference.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/screen/SplashScreen.dart';
import 'package:e_maintenance/service/AuthService.dart';
import 'package:e_maintenance/service/InputService.dart';
import 'package:e_maintenance/service/ReportService.dart';
import 'package:e_maintenance/service/RestartGlassfish.dart';
import 'package:e_maintenance/service/UserService.dart';
import 'package:e_maintenance/app/app_theme.dart';
import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final preferences = await AppPreferences.create();
  final settingsController = AppSettingsController(preferences);
  await settingsController.load();

  final sessionController = SessionController(preferences);
  await sessionController.load();

  final apiClient = AppApiClient(preferences: preferences);
  final messagingHelper = FirebaseMessagingHelper();
  await messagingHelper.initialize(onPayloadOpen: AppRouter.handleNotificationPayload);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppPreferences>.value(value: preferences),
        Provider<AppApiClient>.value(value: apiClient),
        Provider<FirebaseMessagingHelper>.value(value: messagingHelper),
        Provider<AuthService>(
          create: (_) => AuthService(apiClient: apiClient, preferences: preferences),
        ),
        Provider<InputService>(
          create: (_) => InputService(apiClient: apiClient, preferences: preferences),
        ),
        Provider<ReportService>(
          create: (_) => ReportService(apiClient: apiClient, preferences: preferences),
        ),
        Provider<UserService>(
          create: (_) => UserService(apiClient: apiClient),
        ),
        Provider<RestartGlassfishService>(
          create: (_) => const RestartGlassfishService(),
        ),
        ChangeNotifierProvider<AppSettingsController>.value(value: settingsController),
        ChangeNotifierProvider<SessionController>.value(value: sessionController),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsController>(
      builder: (context, settingsController, _) {
        return MaterialApp(
          title: AppEnvironment.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: AppRouter.navigatorKey,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settingsController.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
