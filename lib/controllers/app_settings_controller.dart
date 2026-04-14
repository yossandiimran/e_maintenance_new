import 'package:flutter/material.dart';

import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/helper/preference.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController(this._preferences);

  final AppPreferences _preferences;

  ThemeMode _themeMode = ThemeMode.light;
  String _hostOverride = '';
  Map<String, String> _remoteSettings = <String, String>{};

  ThemeMode get themeMode => _themeMode;
  String get hostOverride => _hostOverride;
  String get activeHost => _hostOverride.isNotEmpty ? _hostOverride : AppEnvironment.defaultApiHost;
  Map<String, String> get remoteSettings => Map<String, String>.unmodifiable(_remoteSettings);

  Future<void> load() async {
    _themeMode = _preferences.readThemeMode();
    _hostOverride = _preferences.hostOverride;
    _remoteSettings = _preferences.readRemoteSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    await _preferences.saveThemeMode(value);
    notifyListeners();
  }

  Future<void> setHostOverride(String value) async {
    _hostOverride = value.trim();
    await _preferences.saveHostOverride(_hostOverride);
    notifyListeners();
  }

  Future<void> syncRemoteSettings(Map<String, String> values) async {
    _remoteSettings = Map<String, String>.from(values);
    await _preferences.saveRemoteSettings(values);
    notifyListeners();
  }
}
