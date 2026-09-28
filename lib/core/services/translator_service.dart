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

  static const Map<String, TranslateLanguage> _map = {
    'en': TranslateLanguage.english,
    'es': TranslateLanguage.spanish,
    'fr': TranslateLanguage.french,
    'de': TranslateLanguage.german,
    'zh': TranslateLanguage.chinese,
    'ar': TranslateLanguage.arabic,
    'hi': TranslateLanguage.hindi,
    'pt': TranslateLanguage.portuguese,
    'ru': TranslateLanguage.russian,
    'ja': TranslateLanguage.japanese,
    'ko': TranslateLanguage.korean,
    'it': TranslateLanguage.italian,
    'tr': TranslateLanguage.turkish,
    'nl': TranslateLanguage.dutch,
    'pl': TranslateLanguage.polish,
    'th': TranslateLanguage.thai,
    'vi': TranslateLanguage.vietnamese,
    'id': TranslateLanguage.indonesian,
    'he': TranslateLanguage.hebrew,
    'fa': TranslateLanguage.persian,
    'ur': TranslateLanguage.urdu,
    'bn': TranslateLanguage.bengali,
    'uk': TranslateLanguage.ukrainian,
    'el': TranslateLanguage.greek,
    'cs': TranslateLanguage.czech,
    'ro': TranslateLanguage.romanian,
    'hu': TranslateLanguage.hungarian,
    'sv': TranslateLanguage.swedish,
    'fil': TranslateLanguage.tagalog,
  };

  static const Set<String> translatableCodes = {
    'en','es','fr','de','zh','ar','hi','pt','ru','ja','ko','it','tr','nl',
    'pl','th','vi','id','he','fa','ur','bn','uk','el','cs','ro','hu','sv','fil',
  };

  static bool isTranslatable(String c) => translatableCodes.contains(c.toLowerCase());
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
    } on TranslatorException { rethrow; }
    catch (e) {
      throw TranslatorException(AppErrorCode.modelDownloadFailed, detail: e.toString());
    }
  }

  Future<String> translate({required String text, required String fromBcp, required String toBcp}) async {
    final from = _map[fromBcp.toLowerCase()];
    final to = _map[toBcp.toLowerCase()];
    if (from == null || to == null) throw TranslatorException(AppErrorCode.unsupportedLanguage);
    final t = OnDeviceTranslator(sourceLanguage: from, targetLanguage: to);
    try { return await t.translateText(text); }
    on TranslatorException { rethrow; }
    catch (e) { throw TranslatorException(AppErrorCode.translationFailed, detail: e.toString()); }
    finally { await t.close(); }
  }
}
