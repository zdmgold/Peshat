import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'language_detector.dart';

class TranslatorService {
  final LanguageDetector _languageDetector = LanguageDetector();

  Future<String> translate(String text, String from, String to) async {
    final targetLang = _getTranslateLanguage(to);
    final sourceLang = (from == 'auto' || from.isEmpty)
        ? _getTranslateLanguage(await _languageDetector.detect(text))
        : _getTranslateLanguage(from);

    final translator = OnDeviceTranslator(
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );

    try {
      return await translator.translateText(text);
    } finally {
      await translator.close();
    }
  }

  TranslateLanguage _getTranslateLanguage(String bcpCode) {
    switch (bcpCode.toLowerCase()) {
      case 'en': return TranslateLanguage.english;
      case 'es': return TranslateLanguage.spanish;
      case 'fr': return TranslateLanguage.french;
      case 'de': return TranslateLanguage.german;
      case 'zh': return TranslateLanguage.chinese;
      case 'ar': return TranslateLanguage.arabic;
      case 'hi': return TranslateLanguage.hindi;
      case 'pt': return TranslateLanguage.portuguese;
      case 'ru': return TranslateLanguage.russian;
      case 'ja': return TranslateLanguage.japanese;
      case 'ko': return TranslateLanguage.korean;
      case 'it': return TranslateLanguage.italian;
      case 'tr': return TranslateLanguage.turkish;
      case 'nl': return TranslateLanguage.dutch;
      case 'pl': return TranslateLanguage.polish;
      case 'th': return TranslateLanguage.thai;
      case 'vi': return TranslateLanguage.vietnamese;
      case 'id': return TranslateLanguage.indonesian;
      case 'he': return TranslateLanguage.hebrew;
      case 'fa': return TranslateLanguage.persian;
      case 'ur': return TranslateLanguage.urdu;
      case 'bn': return TranslateLanguage.bengali;
      case 'uk': return TranslateLanguage.ukrainian;
      case 'el': return TranslateLanguage.greek;
      case 'cs': return TranslateLanguage.czech;
      case 'ro': return TranslateLanguage.romanian;
      case 'hu': return TranslateLanguage.hungarian;
      case 'sv': return TranslateLanguage.swedish;
      case 'fil': return TranslateLanguage.tagalog; // Clinical fix: ML Kit uses 'tagalog', not 'filipino'
      // NOTE: my, am, km, lo, si, ne, pa are genuinely unsupported by ML Kit on-device translation.
      // Falling back to English prevents compile errors and runtime crashes for these edge cases.
      default: return TranslateLanguage.english;
    }
  }
}
