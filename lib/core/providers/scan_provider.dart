import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/app_error_code.dart';
import '../models/scan_state.dart';
import '../services/connectivity_check.dart';
import '../services/language_detector.dart';
import '../services/mixed_text.dart';
import '../services/mixed_translation.dart';
import '../services/scan_scripts.dart';
import '../services/text_quality.dart';
import '../services/text_recognizer_service.dart';
import '../services/translator_service.dart';

export '../services/scan_scripts.dart' show isSameLanguage;

class ScanProvider extends ValueNotifier<ScanState> {
  final TextRecognizerService _ocr;
  final TranslatorService _translator;
  final LanguageDetector _detector;
  final Future<bool> Function() _hasInternet;
  bool _cancelled = false;
  int _run = 0;

  ScanProvider({
    Future<bool> Function()? internetCheck,
    TextRecognizerService? ocr,
    TranslatorService? translator,
    LanguageDetector? detector,
  })  : _ocr = ocr ?? TextRecognizerService(),
        _translator = translator ?? TranslatorService(),
        _detector = detector ?? LanguageDetector(),
        _hasInternet = internetCheck ?? hasInternet,
        super(const ScanState.idle());

  Future<void> runImagePipeline({
    required XFile image,
    required String targetLanguage,
    String sourceLanguage = sourceAuto,
  }) async {
    try {
      value = const ScanState.recognizing();
      final recognized = await _ocr
          .recognize(InputImage.fromFilePath(image.path),
              script: scanScriptFor(sourceLanguage))
          .timeout(const Duration(seconds: 30));
      final src = recognized.text.trim();
      if (src.isEmpty) {
        value = const ScanState.error(AppErrorCode.noTextDetected);
        return;
      }
      await _translate(src, targetLanguage,
          knownSource: sourceLanguage == sourceAuto ? null : sourceLanguage);
    } on TimeoutException catch (e) {
      value = ScanState.error(AppErrorCode.timeout, detail: e.toString());
    } on TranslatorException catch (e) {
      value = ScanState.error(e.code, detail: e.detail ?? e.toString());
    } catch (e, st) {
      final trace = st.toString().split('\n').take(4).join('\n');
      value = ScanState.error(AppErrorCode.unknown, detail: '$e\n$trace');
    }
  }

  Future<void> runTextPipeline({
    required String text,
    required String targetLanguage,
    String sourceLanguage = sourceAuto,
  }) async {
    try {
      final src = text.trim();
      if (src.isEmpty) {
        value = const ScanState.error(AppErrorCode.noTextDetected);
        return;
      }
      value = const ScanState.recognizing();
      await _translate(src, targetLanguage,
          preferredSource: sourceLanguage == sourceAuto ? null : sourceLanguage);
    } on TimeoutException catch (e) {
      value = ScanState.error(AppErrorCode.timeout, detail: e.toString());
    } on TranslatorException catch (e) {
      value = ScanState.error(e.code, detail: e.detail ?? e.toString());
    } catch (e, st) {
      final trace = st.toString().split('\n').take(4).join('\n');
      value = ScanState.error(AppErrorCode.unknown, detail: '$e\n$trace');
    }
  }

  // Once the scan is cancelled or the screen is gone, nothing more is shown.
  @override
  set value(ScanState v) {
    if (_cancelled) return;
    super.value = v;
  }

  Future<void> _translate(String src, String targetLanguage,
      {String? knownSource, String? preferredSource}) async {
    final run = ++_run;
    if (MixedText.isMixed(src)) {
      await _translateMixed(src, targetLanguage, knownSource ?? preferredSource, run);
      return;
    }
    String srcLang = 'en';
    if (knownSource != null) {
      srcLang = knownSource;
    } else {
      var undetermined = false;
      try {
        final d =
            await _detector.detect(src).timeout(const Duration(seconds: 5));
        if (d.isNotEmpty && d != 'und') {
          srcLang = d;
        } else {
          undetermined = true;
        }
      } catch (_) {}
      // Detection can mix up look-alike languages on short text (Macedonian as
      // Bulgarian), or not recognise a language at all (Filipino, Welsh). If
      // the user chose a source in either case, trust their choice.
      if (preferredSource != null &&
          (undetermined || confusableWith(srcLang, preferredSource))) {
        srcLang = preferredSource;
      } else if (!undetermined && !TranslatorService.isTranslatable(srcLang)) {
        // Detected a language there is no model for (Nepali for Hindi-looking
        // text): use its close relative, or the user's own choice if that is
        // the same kind of text.
        final standIn = unsupportedStandIn[srcLang];
        if (standIn != null) {
          srcLang = preferredSource != null &&
                  confusableWith(standIn, preferredSource)
              ? preferredSource
              : standIn;
        } else if (TextQuality.isShortLatin(src)) {
          // A word or two ("Gujarati sample", a name) gives detection too
          // little to go on and it names some rare language. Treat it as
          // English rather than saying the language is not supported.
          srcLang = 'en';
        }
      }
    }
    await _translateWhole(src, srcLang, targetLanguage, run);
  }

  /// All of [src] through the one model for [srcLang].
  Future<void> _translateWhole(
      String src, String srcLang, String targetLanguage, int run) async {
    if (isSameLanguage(srcLang, targetLanguage)) {
      value = ScanDone(
        sourceText: src,
        translatedText: src,
        sourceLanguage: srcLang,
        targetLanguage: targetLanguage,
        sameLanguage: true,
      );
      return;
    }
    if (_cancelled) return;
    final missing = await _translator.missingPacks(
        fromBcp: srcLang, toBcp: targetLanguage);
    if (_cancelled) return;
    if (!await _ensurePacks(missing, run)) return;
    value = ScanTranslating(src, srcLang);
    final translated = await _translator
        .translate(text: src, fromBcp: srcLang, toBcp: targetLanguage)
        .timeout(const Duration(seconds: 60));
    if (_cancelled) return;
    value = ScanDone(
      sourceText: src,
      translatedText: translated,
      sourceLanguage: srcLang,
      targetLanguage: targetLanguage,
    );
  }

  /// Receives the language packs still missing. False when the scan stopped:
  /// no internet, too slow, or cancelled (the error is already shown).
  Future<bool> _ensurePacks(List<String> missing, int run) async {
    if (missing.isEmpty) return true;
    if (!await _hasInternet()) {
      if (_cancelled) return false;
      value = const ScanState.error(AppErrorCode.offlinePackNeeded);
      return false;
    }
    try {
      await _receivePacks(missing, run).timeout(const Duration(minutes: 3));
    } on TimeoutException {
      _run++; // stop the slow pack loop from touching the screen later
      if (_cancelled) return false;
      value = const ScanState.error(AppErrorCode.packTooSlow);
      return false;
    }
    if (_cancelled) return false;
    value = const ScanState.packReceived();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return !_cancelled;
  }

  /// Text with Latin and another script together (a sign in English over a
  /// Hindi line, a menu with Japanese names, a Hindi sentence with "office" in
  /// it). A foreign sentence with a few Latin words inside goes through the
  /// foreign model whole; otherwise each run goes to the model for its own
  /// language, so the English is left as it is. See [MixedTranslation].
  Future<void> _translateMixed(
      String src, String targetLanguage, String? chosen, int run) async {
    final mt = MixedTranslation(_detector);
    final whole = await mt.wholeTextLanguage(src, chosen);
    if (_cancelled) return;
    if (whole != null) {
      if (isSameLanguage(whole, targetLanguage)) {
        value = ScanDone(
          sourceText: src,
          translatedText: src,
          sourceLanguage: whole,
          targetLanguage: targetLanguage,
          sameLanguage: true,
        );
        return;
      }
      await _translateWhole(src, whole, targetLanguage, run);
      return;
    }
    final plan = await mt.plan(src, targetLanguage, preferredSource: chosen);
    if (_cancelled) return;
    final languages = MixedTranslation.languagesIn(plan);
    final main = MixedTranslation.mainLanguage(plan);
    if (languages.isEmpty) {
      value = ScanDone(
        sourceText: src,
        translatedText: src,
        sourceLanguage: targetLanguage,
        targetLanguage: targetLanguage,
        sameLanguage: true,
      );
      return;
    }
    final missing = <String>{};
    for (final from in languages) {
      missing.addAll(await _translator.missingPacks(
          fromBcp: from, toBcp: targetLanguage));
    }
    if (_cancelled) return;
    if (!await _ensurePacks(missing.toList(), run)) return;
    value = ScanTranslating(src, main);
    final translated = await MixedTranslation.run(
      plan,
      targetLanguage,
      (text, from, to) => _translator
          .translate(text: text, fromBcp: from, toBcp: to)
          .timeout(const Duration(seconds: 60)),
    );
    if (_cancelled) return;
    value = ScanDone(
      sourceText: src,
      translatedText: translated,
      sourceLanguage: main,
      targetLanguage: targetLanguage,
    );
  }

  Future<void> _receivePacks(List<String> codes, int run) async {
    for (final c in codes) {
      if (_cancelled || run != _run) return;
      value = ScanState.receivingPack(c);
      await _translator.receivePack(c);
    }
    if (run != _run) return;
  }

  /// Stops the running scan: nothing further is shown, saved or counted.
  void cancel() {
    _cancelled = true;
  }

  void reset() => value = const ScanState.idle();

  @override
  void dispose() {
    _cancelled = true;
    _ocr.dispose();
    _detector.dispose();
    super.dispose();
  }
}
