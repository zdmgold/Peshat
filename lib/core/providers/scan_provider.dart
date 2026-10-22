import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/app_error_code.dart';
import '../models/scan_state.dart';
import '../services/connectivity_check.dart';
import '../services/language_detector.dart';
import '../services/scan_scripts.dart';
import '../services/text_quality.dart';
import '../services/text_recognizer_service.dart';
import '../services/translator_service.dart';

/// True when two BCP-47 codes name the same base language ('en' / 'en-US').
bool isSameLanguage(String a, String b) =>
    a.toLowerCase().split(RegExp('[-_]')).first ==
    b.toLowerCase().split(RegExp('[-_]')).first;

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
    String srcLang = 'en';
    if (knownSource != null) {
      srcLang = knownSource;
    } else {
      var undetermined = false;
      try {
        // Mixed text: judge the foreign part (a caption in English beside
        // Hindi would otherwise be detected as English or Nepali).
        final d = await _detector
            .detect(TextQuality.foreignCore(src) ?? src)
            .timeout(const Duration(seconds: 5));
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
        }
      }
    }
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
    if (missing.isNotEmpty) {
      if (!await _hasInternet()) {
        if (_cancelled) return;
        value = const ScanState.error(AppErrorCode.offlinePackNeeded);
        return;
      }
      try {
        await _receivePacks(missing, run).timeout(const Duration(minutes: 3));
      } on TimeoutException {
        _run++; // stop the slow pack loop from touching the screen later
        if (_cancelled) return;
        value = const ScanState.error(AppErrorCode.packTooSlow);
        return;
      }
      if (_cancelled) return;
      value = const ScanState.packReceived();
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (_cancelled) return;
    }
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
