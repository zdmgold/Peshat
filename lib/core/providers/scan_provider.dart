import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/app_error_code.dart';
import '../models/scan_state.dart';
import '../services/language_detector.dart';
import '../services/text_recognizer_service.dart';
import '../services/translator_service.dart';

class ScanProvider extends ValueNotifier<ScanState> {
  final TextRecognizerService _ocr;
  final TranslatorService _translator;
  final LanguageDetector _detector;

  ScanProvider({
    TextRecognizerService? ocr,
    TranslatorService? translator,
    LanguageDetector? detector,
  })  : _ocr = ocr ?? TextRecognizerService(),
        _translator = translator ?? TranslatorService(),
        _detector = detector ?? LanguageDetector(),
        super(const ScanState.idle());

  Future<void> runImagePipeline({
    required XFile image,
    required String targetLanguage,
  }) async {
    try {
      value = const ScanState.recognizing();
      final recognized = await _ocr
          .recognize(InputImage.fromFilePath(image.path))
          .timeout(const Duration(seconds: 30));
      final src = recognized.text.trim();
      if (src.isEmpty) {
        value = const ScanState.error(AppErrorCode.noTextDetected);
        return;
      }
      await _translate(src, targetLanguage);
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
  }) async {
    try {
      final src = text.trim();
      if (src.isEmpty) {
        value = const ScanState.error(AppErrorCode.noTextDetected);
        return;
      }
      value = const ScanState.recognizing();
      await _translate(src, targetLanguage);
    } on TimeoutException catch (e) {
      value = ScanState.error(AppErrorCode.timeout, detail: e.toString());
    } on TranslatorException catch (e) {
      value = ScanState.error(e.code, detail: e.detail ?? e.toString());
    } catch (e, st) {
      final trace = st.toString().split('\n').take(4).join('\n');
      value = ScanState.error(AppErrorCode.unknown, detail: '$e\n$trace');
    }
  }

  Future<void> _translate(String src, String targetLanguage) async {
    String srcLang = 'en';
    try {
      final d = await _detector.detect(src).timeout(const Duration(seconds: 5));
      if (d.isNotEmpty && d != 'und') srcLang = d;
    } catch (_) {}
    value = ScanPreparingModel(targetLanguage);
    await _translator
        .ensureModelsReady(fromBcp: srcLang, toBcp: targetLanguage)
        .timeout(const Duration(minutes: 3));
    value = ScanTranslating(src, srcLang);
    final translated = await _translator
        .translate(text: src, fromBcp: srcLang, toBcp: targetLanguage)
        .timeout(const Duration(seconds: 60));
    value = ScanDone(
      sourceText: src,
      translatedText: translated,
      sourceLanguage: srcLang,
      targetLanguage: targetLanguage,
    );
  }

  void reset() => value = const ScanState.idle();

  @override
  void dispose() {
    _ocr.dispose();
    _detector.dispose();
    super.dispose();
  }
}
