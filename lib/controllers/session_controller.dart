import 'package:flutter/material.dart';

import 'package:e_maintenance/helper/preference.dart';
import 'package:e_maintenance/model/app_models.dart';

class SessionController extends ChangeNotifier {
  SessionController(this._preferences);

  final AppPreferences _preferences;

  UserSession? _session;

  UserSession? get session => _session;
  bool get isLoggedIn => _session != null;

  Future<void> load() async {
    _session = _preferences.readSession();
    notifyListeners();
  }

  Future<void> setSession(UserSession session) async {
    _session = session;
    await _preferences.saveSession(session);
    notifyListeners();
  }

  Future<void> logout() async {
    _session = null;
    await _preferences.clearSession();
    notifyListeners();
  }
}
