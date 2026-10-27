import 'dart:ui' show Locale;
import '../../l10n/app_localizations.dart';

/// Norwegian Bokmål/Nynorsk device locales use the app's Norwegian strings;
/// older Android reports Filipino as `tl`, the app's strings are `fil`.
String _uiCode(String code) => (code == 'nb' || code == 'nn')
    ? 'no'
    : code == 'tl'
        ? 'fil'
        : code;

/// True when the app ships UI strings for [languageCode].
bool isUiLanguageSupported(String languageCode) => AppLocalizations
    .supportedLocales
    .any((l) => l.languageCode == _uiCode(languageCode));

/// Maps any [locale] to one the app has strings for, falling back to English.
Locale resolveSupportedLocale(Locale? locale) {
  if (locale != null && isUiLanguageSupported(locale.languageCode)) {
    return Locale(_uiCode(locale.languageCode));
  }
  return const Locale('en');
}

/// Device-locale resolution for the app: first preferred language that has
/// strings, otherwise English (Flutter's default would pick the first
/// supported locale, which is Amharic).
Locale resolveDeviceLocales(List<Locale>? locales, Iterable<Locale> supported) {
  for (final l in locales ?? const <Locale>[]) {
    final code = _uiCode(l.languageCode);
    if (supported.any((s) => s.languageCode == code)) {
      return Locale(code);
    }
  }
  return const Locale('en');
}
