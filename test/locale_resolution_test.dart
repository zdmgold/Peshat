import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/models/language.dart';
import 'package:peshat/core/utils/locale_resolution.dart';
import 'package:peshat/l10n/app_localizations.dart';

void main() {
  test('unsupported language falls back to English', () {
    expect(resolveSupportedLocale(const Locale('af')), const Locale('en'));
    expect(resolveSupportedLocale(null), const Locale('en'));
  });

  test('supported language keeps its code and drops the country', () {
    expect(resolveSupportedLocale(const Locale('de', 'AT')), const Locale('de'));
  });

  test('Norwegian Bokmål and Nynorsk map to the Norwegian strings', () {
    expect(resolveSupportedLocale(const Locale('nb', 'NO')), const Locale('no'));
    expect(resolveSupportedLocale(const Locale('nn')), const Locale('no'));
  });

  test('device list resolution picks first supported, else English', () {
    const supported = AppLocalizations.supportedLocales;
    expect(
      resolveDeviceLocales(const [Locale('af'), Locale('fr', 'CA')], supported),
      const Locale('fr'),
    );
    expect(resolveDeviceLocales(const [Locale('af')], supported),
        const Locale('en'));
    expect(resolveDeviceLocales(null, supported), const Locale('en'));
  });

  test('exactly 48 app languages are selectable and all load', () async {
    final ui = supportedLanguages
        .where((l) => isUiLanguageSupported(l.code))
        .toList();
    expect(ui.length, AppLocalizations.supportedLocales.length);
    for (final l in ui) {
      await AppLocalizations.delegate.load(Locale(l.code));
    }
  });
}
