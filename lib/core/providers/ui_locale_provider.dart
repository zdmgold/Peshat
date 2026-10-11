import 'dart:ui' show Locale;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/locale_resolution.dart';

/// Owns the user's chosen UI language. `null` means "follow the device".
class UiLocaleProvider extends ValueNotifier<Locale?> {
  static const _key = 'ui_locale';
  final SharedPreferences prefs;

  UiLocaleProvider(this.prefs) : super(_load(prefs));

  static Locale? _load(SharedPreferences p) {
    final s = p.getString(_key);
    if (s == null || s.isEmpty || s == 'system') return null;
    // A saved language without UI strings (e.g. from an older build) would
    // crash localization lookup, so fall back to "follow system".
    if (!isUiLanguageSupported(s)) return null;
    return Locale(s);
  }

  void setLocale(Locale? locale) {
    value = locale;
    if (locale == null) {
      prefs.setString(_key, 'system');
    } else {
      prefs.setString(_key, locale.languageCode);
    }
  }
}
