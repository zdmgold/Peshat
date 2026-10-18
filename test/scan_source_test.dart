import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart' show XFile;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/providers/settings_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/scan_scripts.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';
import 'package:peshat/core/services/translator_service.dart';
import 'package:peshat/core/models/language.dart';

class _Ocr implements TextRecognizerService {
  TextRecognitionScript? usedScript;
  bool called = false;
  @override
  Future<RecognizedText> recognize(InputImage image,
      {TextRecognitionScript? script}) async {
    called = true;
    usedScript = script;
    return RecognizedText(text: 'konnichiwa', blocks: []);
  }

  @override
  void dispose() {}
}

class _Detector implements LanguageDetector {
  bool called = false;
  @override
  Future<String> detect(String text) async {
    called = true;
    return 'fi';
  }

  @override
  void dispose() {}
}

class _Translator implements TranslatorService {
  String? from;
  @override
  Future<List<String>> missingPacks(
          {required String fromBcp, required String toBcp}) async =>
      [];
  @override
  Future<void> receivePack(String code) async {}
  @override
  Future<void> ensureModelsReady(
          {required String fromBcp, required String toBcp}) async {}
  @override
  Future<String> translate(
      {required String text,
      required String fromBcp,
      required String toBcp}) async {
    from = fromBcp;
    return 'T:$text';
  }
}

void main() {
  test('every translatable language is either readable by a reader or type-only', () {
    final codes = supportedLanguages
        .map((l) => l.code)
        .where(TranslatorService.isTranslatable)
        .toList();
    expect(codes.length, 59);
    for (final c in cameraTypeOnly) {
      expect(TranslatorService.isTranslatable(c), isTrue, reason: c);
      expect(scanScriptFor(c), isNull, reason: c);
      expect(cameraCanRead(c), isFalse, reason: c);
    }
    expect(cameraTypeOnly.length, 17);
    expect(codes.where(cameraCanRead).length, 42);
    expect(codes.where((c) => scanScriptFor(c) != null).length, 42);
  });

  test('each source language picks its own reader', () {
    expect(scanScriptFor('ja'), TextRecognitionScript.japanese);
    expect(scanScriptFor('zh'), TextRecognitionScript.chinese);
    expect(scanScriptFor('ko'), TextRecognitionScript.korean);
    expect(scanScriptFor('hi'), TextRecognitionScript.devanagiri);
    expect(scanScriptFor('mr'), TextRecognitionScript.devanagiri);
    for (final c in ['en', 'fr', 'es', 'de', 'tr', 'vi', 'id', 'fil']) {
      expect(scanScriptFor(c), TextRecognitionScript.latin, reason: c);
    }
    expect(scanScriptFor(sourceAuto), isNull);
    expect(cameraCanRead(sourceAuto), isTrue);
  });

  test('chosen source runs only that reader and skips language detection', () async {
    final ocr = _Ocr(), det = _Detector(), tr = _Translator();
    final p = ScanProvider(
        ocr: ocr, detector: det, translator: tr, internetCheck: () async => true);
    await p.runImagePipeline(
        image: XFile('x.png'), targetLanguage: 'fr', sourceLanguage: 'ja');
    expect(ocr.usedScript, TextRecognitionScript.japanese);
    expect(det.called, isFalse);
    expect(tr.from, 'ja');
    expect((p.value as ScanDone).sourceLanguage, 'ja');
  });

  test('Auto keeps today\'s behaviour: reader order and detection', () async {
    final ocr = _Ocr(), det = _Detector(), tr = _Translator();
    final p = ScanProvider(
        ocr: ocr, detector: det, translator: tr, internetCheck: () async => true);
    await p.runImagePipeline(image: XFile('x.png'), targetLanguage: 'fr');
    expect(ocr.usedScript, isNull);
    expect(det.called, isTrue);
    expect(tr.from, 'fi');
  });

  test('source choice is remembered and bad values fall back to Auto', () async {
    SharedPreferences.setMockInitialValues({});
    var prefs = await SharedPreferences.getInstance();
    var s = SettingsProvider(prefs);
    expect(s.source.value, sourceAuto);
    s.setSource('ja');
    expect(SettingsProvider(prefs).source.value, 'ja');
    s.setSource('zz');
    expect(s.source.value, 'ja');
    s.setSource(sourceAuto);
    expect(SettingsProvider(prefs).source.value, sourceAuto);
    SharedPreferences.setMockInitialValues({'source_language': 'zz'});
    prefs = await SharedPreferences.getInstance();
    expect(SettingsProvider(prefs).source.value, sourceAuto);
  });
}
