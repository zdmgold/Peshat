import 'dart:ui' show Locale;
import '../../l10n/app_localizations.dart';

/// True when the app ships UI strings for [languageCode].
bool isUiLanguageSupported(String languageCode) => AppLocalizations
    .supportedLocales
    .any((l) => l.languageCode == languageCode);

/// Maps any [locale] to one the app has strings for, falling back to English.
Locale resolveSupportedLocale(Locale? locale) {
  if (locale != null && isUiLanguageSupported(locale.languageCode)) {
    return Locale(locale.languageCode);
  }
  return const Locale('en');
}

/// Device-locale resolution for the app: first preferred language that has
/// strings, otherwise English (Flutter's default would pick the first
/// supported locale, which is Amharic).
Locale resolveDeviceLocales(List<Locale>? locales, Iterable<Locale> supported) {
  for (final l in locales ?? const <Locale>[]) {
    if (supported.any((s) => s.languageCode == l.languageCode)) {
      return Locale(l.languageCode);
    }
  }
  return const Locale('en');
}
