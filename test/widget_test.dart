import 'package:e_maintenance/app/app_theme.dart';
import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/helper/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_maintenance/model/TodoModels.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/ConfigSetting.dart';
import 'package:e_maintenance/screen/Login.dart';
import 'package:e_maintenance/service/AuthService.dart';
import 'package:e_maintenance/service/InputService.dart';
import 'package:e_maintenance/service/ReportService.dart';
import 'package:e_maintenance/service/RestartGlassfish.dart';
import 'package:e_maintenance/service/UserService.dart';

Future<Widget> _buildTestApp(
  Widget child, {
  ThemeMode initialThemeMode = ThemeMode.light,
  UserSession? session,
  String host = '10.0.0.7',
}) async {
  SharedPreferences.setMockInitialValues({
    'theme_mode': initialThemeMode == ThemeMode.dark ? 'dark' : 'light',
    'globalIp': host,
  });

  final preferences = await AppPreferences.create();
  final settingsController = AppSettingsController(preferences);
  await settingsController.load();

  final sessionController = SessionController(preferences);
  await sessionController.load();
  if (session != null) {
    await sessionController.setSession(session);
  }

  final apiClient = AppApiClient(preferences: preferences);

  return MultiProvider(
    providers: [
      Provider<AppPreferences>.value(value: preferences),
      Provider<AppApiClient>.value(value: apiClient),
      Provider<AuthService>(
        create: (_) =>
            AuthService(apiClient: apiClient, preferences: preferences),
      ),
      Provider<InputService>(
        create: (_) =>
            InputService(apiClient: apiClient, preferences: preferences),
      ),
      Provider<ReportService>(
        create: (_) =>
            ReportService(apiClient: apiClient, preferences: preferences),
      ),
      Provider<UserService>(
        create: (_) => UserService(apiClient: apiClient),
      ),
      Provider<RestartGlassfishService>(
        create: (_) => const RestartGlassfishService(),
      ),
      ChangeNotifierProvider<AppSettingsController>.value(
          value: settingsController),
      ChangeNotifierProvider<SessionController>.value(value: sessionController),
    ],
    child: Consumer<AppSettingsController>(
      builder: (context, settings, _) {
        return MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode,
          home: child,
        );
      },
    ),
  );
}

void main() {
  test('Todo.fromJson maps API payload into model fields', () {
    final todo = Todo.fromJson({
      'id': 7,
      'title': 'Periksa rem',
      'description': 'Cek kondisi kampas rem',
      '_is_done': 1,
      'tanggal': '2026-04-13',
      'jp': 'Harian',
    });

    expect(todo.id, 7);
    expect(todo.title, 'Periksa rem');
    expect(todo.description, 'Cek kondisi kampas rem');
    expect(todo.isDone, isTrue);
    expect(todo.dueDate, '2026-04-13');
    expect(todo.jp, 'Harian');
  });

  test('Todo.fromJson keeps unfinished item as false', () {
    final todo = Todo.fromJson({
      'id': 8,
      'title': 'Periksa oli',
      'description': 'Pastikan level oli aman',
      '_is_done': 0,
      'tanggal': '2026-04-14',
      'jp': 'Mingguan',
    });

    expect(todo.isDone, isFalse);
    expect(todo.dueDate, '2026-04-14');
  });

  testWidgets('Login screen validates required username with default password',
      (tester) async {
    await tester.pumpWidget(await _buildTestApp(const Login()));

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Username wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsNothing);
  });

  testWidgets('Settings page toggles dark mode through the settings controller',
      (tester) async {
    final session = UserSession(
      id: 1,
      username: 'admin',
      name: 'Admin',
      usap: 'usap',
      psap: 'psap',
      werks: 'CKR',
      roleId: '1',
    );

    await tester.pumpWidget(
      await _buildTestApp(
        const ConfigSettingPage(),
        session: session,
        initialThemeMode: ThemeMode.light,
      ),
    );

    final themeToggle = find.byIcon(Icons.dark_mode_rounded);
    expect(themeToggle, findsOneWidget);

    await tester.tap(themeToggle);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ConfigSettingPage));
    final controller =
        Provider.of<AppSettingsController>(context, listen: false);
    expect(controller.themeMode, ThemeMode.dark);
  });
}
