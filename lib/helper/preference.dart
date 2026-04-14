import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_maintenance/model/app_models.dart';

class AppPreferences {
  AppPreferences._(this._prefs);

  static const String _themeModeKey = 'theme_mode';
  static const String _hostOverrideKey = 'globalIp';
  static const String _remoteSettingKeysKey = 'remote_setting_keys';

  static const List<String> _sessionKeys = <String>[
    'id',
    'username',
    'nama',
    'usap',
    'psap',
    'werks',
    'id_jenis_user',
    'login_timestamp',
  ];

  final SharedPreferences _prefs;

  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences._(prefs);
  }

  ThemeMode readThemeMode() {
    switch (_prefs.getString(_themeModeKey)) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) {
    final value = mode == ThemeMode.dark ? 'dark' : 'light';
    return _prefs.setString(_themeModeKey, value);
  }

  String get hostOverride => (_prefs.getString(_hostOverrideKey) ?? '').trim();

  Future<void> saveHostOverride(String value) async {
    final sanitized = value.trim();
    if (sanitized.isEmpty) {
      await _prefs.remove(_hostOverrideKey);
      return;
    }
    await _prefs.setString(_hostOverrideKey, sanitized);
  }

  Future<void> saveSession(UserSession session) async {
    final map = session.toPreferencesMap();
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is int) {
        await _prefs.setInt(entry.key, value);
      } else {
        await _prefs.setString(entry.key, '$value');
      }
    }
  }

  UserSession? readSession() {
    final id = _prefs.getInt('id');
    if (id == null) {
      return null;
    }

    return UserSession(
      id: id,
      username: _prefs.getString('username') ?? '',
      name: _prefs.getString('nama') ?? '',
      usap: _prefs.getString('usap') ?? '',
      psap: _prefs.getString('psap') ?? '',
      werks: _prefs.getString('werks') ?? '',
      roleId: _prefs.getString('id_jenis_user') ?? '',
      loginTimestamp: _prefs.getInt('login_timestamp'),
    );
  }

  Future<void> clearSession() async {
    for (final key in _sessionKeys) {
      await _prefs.remove(key);
    }
  }

  Future<void> saveRemoteSettings(Map<String, String> values) async {
    final keys = values.keys.toList()..sort();
    await _prefs.setStringList(_remoteSettingKeysKey, keys);
    for (final entry in values.entries) {
      await _prefs.setString(entry.key, entry.value);
    }
  }

  Map<String, String> readRemoteSettings() {
    final keys = _prefs.getStringList(_remoteSettingKeysKey) ?? <String>[];
    return <String, String>{
      for (final key in keys) key: _prefs.getString(key) ?? '',
    };
  }

  String get manualServiceBaseUrl {
    final sap = getString('urlsap');
    if (sap.isNotEmpty) {
      return sap;
    }
    return getString('url');
  }

  String getString(String key) => (_prefs.getString(key) ?? '').trim();

  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setString(String key, String value) => _prefs.setString(key, value);
}
