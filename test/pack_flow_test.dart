import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:peshat/core/models/app_error_code.dart';
import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';
import 'package:peshat/core/services/translator_service.dart';

class _FakeOcr implements TextRecognizerService {
  @override
  Future<RecognizedText> recognize(InputImage image,
          {TextRecognitionScript? script}) =>
      throw UnimplementedError();
  @override
  void dispose() {}
}

class _FakeDetector implements LanguageDetector {
  final String lang;
  _FakeDetector(this.lang);
  @override
  Future<String> detect(String text) async => lang;
  @override
  void dispose() {}
}

class _FakeTranslator implements TranslatorService {
  final List<String> missing;
  final List<String> received = [];
  _FakeTranslator(this.missing);
  @override
  Future<List<String>> missingPacks(
          {required String fromBcp, required String toBcp}) async =>
      List.of(missing);
  @override
  Future<void> receivePack(String code) async => received.add(code);
  @override
  Future<void> ensureModelsReady(
          {required String fromBcp, required String toBcp}) async {}
  @override
  Future<String> translate(
          {required String text,
          required String fromBcp,
          required String toBcp}) async =>
      'T:$text';
}

ScanProvider _make(List<String> missing, {required bool online, String lang = 'en'}) =>
    ScanProvider(
      ocr: _FakeOcr(),
      translator: _FakeTranslator(missing),
      detector: _FakeDetector(lang),
      internetCheck: () async => online,
    );

void main() {
  test('pack on the phone: no receiving bar, goes straight to translating', () async {
    final p = _make([], online: false);
    final seen = <Type>[];
    p.addListener(() => seen.add(p.value.runtimeType));
    await p.runTextPipeline(text: 'hello', targetLanguage: 'de');
    expect(seen, [ScanRecognizing, ScanTranslating, ScanDone]);
  });

  test('pack missing and offline: offline error, nothing received', () async {
    final p = _make(['de'], online: false);
    await p.runTextPipeline(text: 'hello', targetLanguage: 'de');
    final s = p.value;
    expect(s, isA<ScanError>());
    expect((s as ScanError).code, AppErrorCode.offlinePackNeeded);
  });

  test('pack missing and online: receiving, received, then translated', () async {
    final p = _make(['de', 'fr'], online: true);
    final seen = <String>[];
    p.addListener(() {
      final v = p.value;
      seen.add(v is ScanReceivingPack ? 'receiving:${v.current}' : v.runtimeType.toString());
    });
    await p.runTextPipeline(text: 'hello', targetLanguage: 'de');
    expect(seen, [
      'ScanRecognizing',
      'receiving:de',
      'receiving:fr',
      'ScanPackReceived',
      'ScanTranslating',
      'ScanDone',
    ]);
  });

  test('same language: no packs needed, nothing translated', () async {
    final p = _make(['de'], online: false);
    await p.runTextPipeline(text: 'hello', targetLanguage: 'en');
    final s = p.value;
    expect(s, isA<ScanDone>());
    expect((s as ScanDone).sameLanguage, isTrue);
  });

  test('cancel stops the scan: nothing further is shown', () async {
    final p = _make(['de'], online: true);
    final future = p.runTextPipeline(text: 'hello', targetLanguage: 'de');
    p.cancel();
    await future;
    expect(p.value, isNot(isA<ScanDone>()));
  });
}
