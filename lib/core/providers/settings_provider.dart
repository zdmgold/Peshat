import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/translator_service.dart';

class SettingsProvider extends ValueNotifier<String> {
  static const _key = 'target_language';
  final SharedPreferences prefs;

  SettingsProvider(this.prefs) : super(_load(prefs));

  static String _load(SharedPreferences p) {
    final s = p.getString(_key);
    if (s != null && s.isNotEmpty && TranslatorService.isTranslatable(s)) return s;
    final dev = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    if (TranslatorService.isTranslatable(dev)) return dev;
    return 'es';
  }

  void setTarget(String code) {
    final n = code.toLowerCase();
    if (!TranslatorService.isTranslatable(n)) return;
    value = n;
    prefs.setString(_key, n);
  }
}
