import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../models/app_error_code.dart';

class TranslatorException implements Exception {
  final AppErrorCode code;
  final String? detail;
  TranslatorException(this.code, {this.detail});
  @override
  String toString() => 'TranslatorException($code)';
}

class TranslatorService {
  final OnDeviceTranslatorModelManager _manager = OnDeviceTranslatorModelManager();

  /// Every language ML Kit on-device translation supports.
  /// Verified against the enum in google_mlkit_translation 0.11.1 —
  /// 59 members, all mapped here.
  static const Map<String, TranslateLanguage> _map = {
    'af': TranslateLanguage.afrikaans,
    'sq': TranslateLanguage.albanian,
    'ar': TranslateLanguage.arabic,
    'be': TranslateLanguage.belarusian,
    'bn': TranslateLanguage.bengali,
    'bg': TranslateLanguage.bulgarian,
    'ca': TranslateLanguage.catalan,
    'zh': TranslateLanguage.chinese,
    'hr': TranslateLanguage.croatian,
    'cs': TranslateLanguage.czech,
    'da': TranslateLanguage.danish,
    'nl': TranslateLanguage.dutch,
    'en': TranslateLanguage.english,
    'eo': TranslateLanguage.esperanto,
    'et': TranslateLanguage.estonian,
    'fi': TranslateLanguage.finnish,
    'fr': TranslateLanguage.french,
    'gl': TranslateLanguage.galician,
    'ka': TranslateLanguage.georgian,
    'de': TranslateLanguage.german,
    'el': TranslateLanguage.greek,
    'gu': TranslateLanguage.gujarati,
    'ht': TranslateLanguage.haitian,
    'he': TranslateLanguage.hebrew,
    'hi': TranslateLanguage.hindi,
    'hu': TranslateLanguage.hungarian,
    'is': TranslateLanguage.icelandic,
    'id': TranslateLanguage.indonesian,
    'ga': TranslateLanguage.irish,
    'it': TranslateLanguage.italian,
    'ja': TranslateLanguage.japanese,
    'kn': TranslateLanguage.kannada,
    'ko': TranslateLanguage.korean,
    'lv': TranslateLanguage.latvian,
    'lt': TranslateLanguage.lithuanian,
    'mk': TranslateLanguage.macedonian,
    'ms': TranslateLanguage.malay,
    'mt': TranslateLanguage.maltese,
    'mr': TranslateLanguage.marathi,
    'no': TranslateLanguage.norwegian,
    'fa': TranslateLanguage.persian,
    'pl': TranslateLanguage.polish,
    'pt': TranslateLanguage.portuguese,
    'ro': TranslateLanguage.romanian,
    'ru': TranslateLanguage.russian,
    'sk': TranslateLanguage.slovak,
    'sl': TranslateLanguage.slovenian,
    'es': TranslateLanguage.spanish,
    'sw': TranslateLanguage.swahili,
    'sv': TranslateLanguage.swedish,
    'fil': TranslateLanguage.tagalog,
    'ta': TranslateLanguage.tamil,
    'te': TranslateLanguage.telugu,
    'th': TranslateLanguage.thai,
    'tr': TranslateLanguage.turkish,
    'uk': TranslateLanguage.ukrainian,
    'ur': TranslateLanguage.urdu,
    'vi': TranslateLanguage.vietnamese,
    'cy': TranslateLanguage.welsh,
  };

  static final Set<String> translatableCodes = _map.keys.toSet();

  static bool isTranslatable(String c) =>
      translatableCodes.contains(c.toLowerCase());

  static TranslateLanguage? languageFor(String c) => _map[c.toLowerCase()];

  Future<void> ensureModelsReady({required String fromBcp, required String toBcp}) async {
    if (!isTranslatable(fromBcp) || !isTranslatable(toBcp)) {
      throw TranslatorException(AppErrorCode.unsupportedLanguage);
    }
    await _ensure(fromBcp.toLowerCase());
    if (fromBcp.toLowerCase() != toBcp.toLowerCase()) {
      await _ensure(toBcp.toLowerCase());
    }
  }

  Future<void> _ensure(String bcp) async {
    try {
      if (await _manager.isModelDownloaded(bcp)) return;
      final ok = await _manager.downloadModel(bcp, isWifiRequired: false);
      if (!ok) throw TranslatorException(AppErrorCode.modelDownloadFailed);
    } on TranslatorException {
      rethrow;
    } catch (e) {
      throw TranslatorException(AppErrorCode.modelDownloadFailed, detail: e.toString());
    }
  }

  Future<String> translate({
    required String text,
    required String fromBcp,
    required String toBcp,
  }) async {
    final from = _map[fromBcp.toLowerCase()];
    final to = _map[toBcp.toLowerCase()];
    if (from == null || to == null) {
      throw TranslatorException(AppErrorCode.unsupportedLanguage);
    }
    final t = OnDeviceTranslator(sourceLanguage: from, targetLanguage: to);
    try {
      return await t.translateText(text);
    } on TranslatorException {
      rethrow;
    } catch (e) {
      throw TranslatorException(AppErrorCode.translationFailed, detail: e.toString());
    } finally {
      await t.close();
    }
  }
}
