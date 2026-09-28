import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/translator_service.dart';

class SettingsProvider extends ValueNotifier<String> {
  static const _key = 'target_language';
  static const _recentKey = 'recent_target_languages';
  static const _recentMax = 3;

  final SharedPreferences prefs;

  SettingsProvider(this.prefs) : super(_load(prefs));

  static String _load(SharedPreferences p) {
    final s = p.getString(_key);
    if (s != null && s.isNotEmpty && TranslatorService.isTranslatable(s)) {
      return s;
    }
    final dev = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    if (TranslatorService.isTranslatable(dev)) return dev;
    return 'es';
  }

  /// Up to three previously selected target languages, newest first.
  /// Excludes the current selection.
  List<String> get recentTargets {
    final raw = prefs.getStringList(_recentKey) ?? const <String>[];
    return raw
        .where((c) =>
            c != value && TranslatorService.isTranslatable(c))
        .take(_recentMax)
        .toList();
  }

  void setTarget(String code) {
    final n = code.toLowerCase();
    if (!TranslatorService.isTranslatable(n)) return;
    final previous = value;
    value = n;
    prefs.setString(_key, n);
    _pushRecent(previous);
  }

  void _pushRecent(String code) {
    if (code.isEmpty) return;
    if (!TranslatorService.isTranslatable(code)) return;
    final list = prefs.getStringList(_recentKey) ?? <String>[];
    list.removeWhere((c) => c == code);
    list.insert(0, code);
    if (list.length > _recentMax) {
      list.removeRange(_recentMax, list.length);
    }
    prefs.setStringList(_recentKey, list);
  }
}
