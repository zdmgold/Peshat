import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme_mode.dart';

class ThemeProvider extends ValueNotifier<AppThemeMode> {
  final SharedPreferences prefs;

  ThemeProvider(this.prefs) : super(_load(prefs));

  static AppThemeMode _load(SharedPreferences p) =>
      AppThemeMode.values.asNameMap()[p.getString('theme_mode')] ??
      AppThemeMode.light;

  void setMode(AppThemeMode mode) {
    value = mode;
    prefs.setString('theme_mode', mode.name);
  }
}
