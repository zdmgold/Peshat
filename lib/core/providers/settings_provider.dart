import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/scan_scripts.dart';
import '../services/translator_service.dart';

class SettingsProvider extends ValueNotifier<String> {
  static const _key = 'target_language';
  static const _recentKey = 'recent_target_languages';
  static const _recentMax = 3;

  static const _sourceKey = 'source_language';

  final SharedPreferences prefs;

  /// The language of the text in photos: [sourceAuto] or a language code.
  /// Decides which text reader the camera and Import use.
  late final ValueNotifier<String> source =
      ValueNotifier<String>(_loadSource(prefs));

  SettingsProvider(this.prefs) : super(_load(prefs));

  static String _loadSource(SharedPreferences p) {
    final s = p.getString(_sourceKey);
    return s != null && TranslatorService.isTranslatable(s) ? s : sourceAuto;
  }

  void setSource(String code) {
    final n = code.toLowerCase();
    if (n != sourceAuto && !TranslatorService.isTranslatable(n)) return;
    source.value = n;
    prefs.setString(_sourceKey, n);
  }

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
