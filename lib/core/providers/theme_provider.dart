import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  final SharedPreferences prefs;
  
  ThemeProvider(this.prefs) : super(_load(prefs));

  static ThemeMode _load(SharedPreferences p) =>
      ThemeMode.values.asNameMap()[p.getString('theme_mode')] ?? ThemeMode.light;

  void setMode(ThemeMode mode) {
    value = mode;
    prefs.setString('theme_mode', mode.name);
  }
}
