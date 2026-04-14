import 'package:flutter/material.dart';

import 'package:e_maintenance/app/app_theme.dart';

extension AppThemeContext on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get textTheme => appTheme.textTheme;
  AppTokens get tokens => appTheme.extension<AppTokens>()!;
  bool get isDarkMode => appTheme.brightness == Brightness.dark;
}
