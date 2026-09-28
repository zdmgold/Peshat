import '../models/language.dart';

/// BCP-47 code -> human-readable English name. Falls back to the code
/// itself if the locale is not in the supported list.
String languageDisplayName(String bcpCode) {
  final lower = bcpCode.toLowerCase();
  for (final lang in supportedLanguages) {
    if (lang.code == lower) return lang.englishName;
  }
  return bcpCode.toUpperCase();
}

/// BCP-47 code -> native-script name (e.g. "العربية" for ar).
String languageNativeName(String bcpCode) {
  final lower = bcpCode.toLowerCase();
  for (final lang in supportedLanguages) {
    if (lang.code == lower) return lang.nativeName;
  }
  return bcpCode.toUpperCase();
}

/// True if the language is right-to-left.
bool languageIsRtl(String bcpCode) {
  final lower = bcpCode.toLowerCase();
  for (final lang in supportedLanguages) {
    if (lang.code == lower) return lang.isRtl;
  }
  return false;
}
