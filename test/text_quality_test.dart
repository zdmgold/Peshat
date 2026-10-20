import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/scan_scripts.dart';
import 'package:peshat/core/services/text_quality.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';
import 'package:peshat/core/services/translator_service.dart';

// [confidence, text] pairs measured on an Android emulator: ML Kit language-id
// confidence and what the Latin reader returned for photos of other scripts
// (garbage) or real Latin-script text.
final List<List<dynamic>> _garbage = (jsonDecode(r'''[[0.27, "Ao\u00f3poe yTpo, Kak y Te\u00f3A gena?"], [0.19, "Ao\u00f3pu\u016d paHOK, AKy Tebe cnpasu?"], [0.26, "Ao\u00f3po yTpo, Kak CM AHec?"], [0.17, "Ao\u00f3po yTpo, KakO CM AeHec?"], [0.15, "Kadnu\u00e9pa, TW\u00c7 eioaL a\u0144u\u025bpa;"], [0.61, "SPgl dl\u611f5\u30546"], [0.56, "9 \u0939\u09e6"], [0.18, "DI'n bu nn,U pn?"], [0.12, "a6aa1uL\u7684\u5f18annLUnu6"], [0.98, "V\u53f8,3T\u53ef3Tq\u3042\u5bfe\u304d"], [0.44, "Hua, 3ATG\u0130 h 318I?"], [0.99, "8\u65e5\u53ef\u53ef,\u53ef\u53ef\u65f6\u7684\u30e6\u56de\u3066?"], [1.0, "\uceec\ub2c8\uc5b4ld, \uc2dc [\uba85 S i?"], [0.68, "5IT6006U 6J600TES ED, 60TmI Br\u00fc56\u0130T 6T\u016eUIg QGHSlBj56\u0130r?"], [0.97, "\u5c0f5ooo, er\u547d)ds?"], [0.22, "onms 8300m\u00f2obo, oggb mmgmm bomn?"], [0.51, "PE, (tRFIIy?"], [1.0, "\u9999201\u5df4E2\u624d\u662f0| 0\u56fd4\u65e6?"], [0.44, "Ao\u00f3poe yTpo, Kaky Te\u00f3a gena?"], [0.19, "Ao\u00f3pu\u1e41 paHok, AKy Tebe cnpaBu?"], [0.26, "Ao\u00f3po yTpo, Kak cM AHec?"], [0.51, "Ao\u00f3pbl A3eHb, AK TBae cpaBbI?"], [0.54, "$ \u098f 5UI >\u09e6"], [0.57, "= \u0939\u094b \u09e6"], [0.43, "DIn ]o\u30d5\u30c3nnaU 1pID?"], [0.2, "aia6npu\u7684ndnnaunu6 Ma"], [0.99, "\u8fce\u53ef,I\u53ef\u897f\u5bf9\u8a2d"], [0.99, "\u8981\u800c,\u53ef\u53ef\u4e0d3I6I?"], [0.99, "8d \u53efp\u53ef, \u53efd\u65f6a\u9a6c\u3066E3?"], [0.96, "\u0938\u0941\u092a\u094d\u0930\u092d\u093e\u0924, I\u0947 \u0924\u092e\u0947\u0902 \u0921\u092d \u0927\u091b?"], [0.12, "5T6060 au6068sb, 9mp\u300d 56T 6ruu4 9566djsdr?"], [0.55, "bltt5TUIT, SEtbL\u00c3TS ?"], [0.97, "\u99992 01LEE 2\u53f0\u5200\u662f0| 01\u56fd2?"]]''') as List)
    .map((e) => e as List<dynamic>)
    .toList();
final List<List<dynamic>> _real = (jsonDecode(r'''[[1.0, "Hello world, good morning"], [1.0, "iPhone 15 Pro Max"], [0.88, "McDonald's open 24 hours"], [0.92, "YouTube Premium"], [1.0, "WiFi password: guest2024"], [0.93, "Room 204B"], [1.0, "USB-C cable 2m"], [0.48, "Caf\u00e9 M\u00fcnch\u00ebn \u2013 Stra\u00dfe 12"], [1.0, "Die Rechnung betr\u00e4gt 45,90 \u20ac"], [1.0, "O\u00f9 est la gare, s'il vous pla\u00eet ?"], [1.0, "\u00bfCu\u00e1nto cuesta esto?"], [0.96, "\u015aroda, 14:30"], [1.0, "Ti\u1ebfng Vi\u1ec7t r\u1ea5t hay"], [1.0, "\u00c7ok te\u015fekk\u00fcr ederim"], [0.44, "STOP"], [0.35, "NO ENTRY"], [0.68, "EXIT 12B"], [0.84, "Total: $18.50"], [0.57, "Tel +44 20 7946 0958"], [1.0, "Order #A4512 shipped"], [1.0, "Mix 2kg flour and 500g sugar"], [0.97, "Dr. Smith, Ph.D."], [1.0, "COVID19 update"], [1.0, "Bonjour tout le monde"], [0.99, "\u010cau, jak se m\u00e1\u0161?"], [0.18, "\u00d1and\u00fa"], [1.0, "Z\u0142oty 100 z\u0142"], [0.6, "Kuala Lumpur"], [0.46, "Good Morning Vietnam"], [0.49, "MacBook Air M2"], [0.52, "1234567890"], [0.51, "12:30"], [0.68, "CO2 emissions"], [0.99, "PlayStation 5"], [1.0, "Please keep this door closed at all times"], [1.0, "Opening hours: Monday to Friday, 9am to 5pm"], [1.0, "Der Zug nach Berlin f\u00e4hrt um 14 Uhr von Gleis 5"], [1.0, "La r\u00e9union commence \u00e0 dix heures demain matin"], [1.0, "El ba\u00f1o est\u00e1 al fondo a la derecha"], [1.0, "Il ristorante \u00e8 chiuso il luned\u00ec"], [0.98, "O supermercado abre \u00e0s oito da manh\u00e3"], [1.0, "Het museum is vandaag gesloten"], [0.99, "Vi \u00f6ppnar klockan nio varje dag"], [1.0, "Dzi\u0119kujemy za zakupy w naszym sklepie"], [1.0, "Bu \u00fcr\u00fcn \u00e7ocuklar i\u00e7in uygun de\u011fildir"], [1.0, "Mul\u021bumim pentru vizit\u0103, revenim cur\u00e2nd"], [1.0, "K\u00e9rj\u00fck, ne doh\u00e1nyozzon az \u00e9p\u00fcletben"], [0.9, "Hvala \u0161to ste posjetili na\u0161 restoran"], [0.85, "Terima kasih telah berbelanja di toko kami"], [1.0, "C\u1ea3m \u01a1n b\u1ea1n \u0111\u00e3 gh\u00e9 th\u0103m c\u1eeda h\u00e0ng"], [0.68, "Salamat sa pagbisita sa aming tindahan"], [0.78, "Asante kwa kutembelea duka letu"], [0.63, "Dankie dat jy ons besoek het"], [0.95, "Gracias por su visita, vuelva pronto"], [0.99, "Ingredients: wheat flour, sugar, palm oil, salt"], [1.0, "Best before end: see top of pack"], [0.98, "Caution wet floor"], [1.0, "Fire exit keep clear"], [0.47, "Pay here"], [0.96, "Sale 50% off"]]''') as List)
    .map((e) => e as List<dynamic>)
    .toList();

class _Det implements LanguageDetector {
  final String code;
  _Det(this.code);
  @override
  Future<String> detect(String text) async => code;
  @override
  void dispose() {}
}

class _Tr implements TranslatorService {
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

TextRecognizerService _service(
    Map<TextRecognitionScript, String> readings, List<TextRecognitionScript> ran,
    {double confidence = 0.9, Map<String, double> reading = const {}}) {
  return TextRecognizerService(
    readingConfidence: (r) => reading[r.text],
    reader: (script, image) async {
      ran.add(script);
      return RecognizedText(text: readings[script] ?? '', blocks: const []);
    },
    confidence: (text) async => confidence,
  );
}

void main() {
  group('Latin reader output', () {
    test('real text is accepted', () {
      for (final e in _real) {
        expect(TextQuality.latinLooksReal(e[1] as String, (e[0] as num).toDouble()),
            isTrue,
            reason: e[1] as String);
      }
    });

    test('look-alike garbage from other scripts is rejected', () {
      for (final e in _garbage) {
        expect(TextQuality.latinLooksReal(e[1] as String, (e[0] as num).toDouble()),
            isFalse,
            reason: e[1] as String);
      }
    });
  });

  group('Auto reading', () {
    test('real Latin text stops at the Latin reader', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service(
          {TextRecognitionScript.latin: 'Good morning, how are you?'}, ran);
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'Good morning, how are you?');
      expect(ran, [TextRecognitionScript.latin]);
    });

    test('Japanese photo: Latin garbage is passed over, Japanese reader wins',
        () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service({
        TextRecognitionScript.latin: 'V司,3T可3Tqあ対き',
        TextRecognitionScript.japanese: 'おはようございます、今日はお元気ですか？',
      }, ran);
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'おはようございます、今日はお元気ですか？');
      expect(ran.first, TextRecognitionScript.latin);
      expect(ran.contains(TextRecognitionScript.japanese), isTrue);
    });

    test('Chinese, Korean and Hindi photos reach their own readers', () async {
      for (final c in <TextRecognitionScript, String>{
        TextRecognitionScript.chinese: '早上好，你今天好吗？',
        TextRecognitionScript.korean: '좋은 아침입니다, 오늘 기분이 어떠세요?',
        TextRecognitionScript.devanagiri: 'सुप्रभात, आज आप कैसे हैं?',
      }.entries) {
        final ran = <TextRecognitionScript>[];
        final svc = _service({
          TextRecognitionScript.latin: 'Aoópoe yTpo, Kak y TeóA gena?',
          c.key: c.value,
        }, ran, confidence: 0.27);
        final r = await svc.recognize(InputImage.fromFilePath('x.png'));
        expect(r.text, c.value, reason: c.key.name);
      }
    });

    test('Cyrillic photo: nothing looks real, so nothing is returned', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service({
        TextRecognitionScript.latin: 'Aoópoe yTpo, Kak y TeóA gena?',
        TextRecognitionScript.chinese: 'Aoópoe yTpo',
        TextRecognitionScript.korean: 'Kak y',
      }, ran, confidence: 0.27);
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, isEmpty);
    });

    test('Latin empty (clean Hindi photo): other readers still get a turn',
        () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service(
          {TextRecognitionScript.devanagiri: 'नमस्ते दुनिया धन्यवाद'}, ran);
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'नमस्ते दुनिया धन्यवाद');
    });

    test('the most confident reading wins, wrong readers are ignored', () async {
      final ran = <TextRecognitionScript>[];
      // Measured on the emulator for a Hindi photo.
      final svc = _service({
        TextRecognitionScript.japanese: 'V司,3T可3Tqあ対き',
        TextRecognitionScript.korean: '니, 3어I 3[4 하 ?',
        TextRecognitionScript.devanagiri: 'सुप्रभात, आज आप कैसे हैं?',
      }, ran, confidence: 0.2, reading: {
        'V司,3T可3Tqあ対き': 0.14,
        '니, 3어I 3[4 하 ?': 0.16,
        'सुप्रभात, आज आप कैसे हैं?': 0.86,
      });
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'सुप्रभात, आज आप कैसे हैं?');
    });

    test('a pure-looking but low-confidence reading is dropped', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service({
        TextRecognitionScript.chinese: '香201巴E2才是0 0国4旦',
      }, ran, confidence: 0.2, reading: {'香201巴E2才是0 0国4旦': 0.21});
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, isEmpty);
    });

    test('Japanese beats Chinese when both read it', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service({
        TextRecognitionScript.japanese: 'おはようございます、今日はお元気ですか？',
        TextRecognitionScript.chinese: 'ですか？',
      }, ran, confidence: 0.2, reading: {
        'おはようございます、今日はお元気ですか？': 0.87,
        'ですか？': 0.64,
      });
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'おはようございます、今日はお元気ですか？');
    });

    test('Bengali is read by the Devanagari reader', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service(
          {TextRecognitionScript.devanagiri: 'শুভ সকাল, আজ আপনি কেমন আছেন?'},
          ran,
          confidence: 0.2,
          reading: {'শুভ সকাল, আজ আপনি কেমন আছেন?': 0.89});
      final r = await svc.recognize(InputImage.fromFilePath('x.png'));
      expect(r.text, 'শুভ সকাল, আজ আপনি কেমন আছেন?');
    });

    test('Latin reading with very low reader confidence is not trusted', () {
      expect(TextQuality.latinLooksReal('t?', 0.5, readingConfidence: 0.42),
          isFalse);
      expect(TextQuality.latinLooksReal('Good morning', 0.9, readingConfidence: 0.9),
          isTrue);
    });

    test('a chosen source still runs only that reader', () async {
      final ran = <TextRecognitionScript>[];
      final svc = _service({TextRecognitionScript.korean: '안녕하세요'}, ran);
      await svc.recognize(InputImage.fromFilePath('x.png'),
          script: TextRecognitionScript.korean);
      expect(ran, [TextRecognitionScript.korean]);
    });
  });

  group('typed text with a chosen source', () {
    test('a look-alike language in the same script follows the choice', () {
      expect(confusableWith('bg', 'mk'), isTrue);
      expect(confusableWith('hi', 'mr'), isTrue);
      expect(confusableWith('en', 'mk'), isFalse);
      expect(confusableWith('mk', 'mk'), isFalse);
    });

    test('Macedonian word detected as Bulgarian uses the chosen Macedonian',
        () async {
      final tr = _Tr();
      final p = ScanProvider(
          detector: _Det('bg'), translator: tr, internetCheck: () async => true);
      await p.runTextPipeline(
          text: 'Здраво', targetLanguage: 'en', sourceLanguage: 'mk');
      expect(tr.from, 'mk');
      expect((p.value as ScanDone).sourceLanguage, 'mk');
    });

    test('an unrelated chosen source never overrides detection', () async {
      final tr = _Tr();
      final p = ScanProvider(
          detector: _Det('en'), translator: tr, internetCheck: () async => true);
      await p.runTextPipeline(
          text: 'Hello', targetLanguage: 'fr', sourceLanguage: 'ja');
      expect(tr.from, 'en');
    });

    test('Auto keeps plain detection', () async {
      final tr = _Tr();
      final p = ScanProvider(
          detector: _Det('bg'), translator: tr, internetCheck: () async => true);
      await p.runTextPipeline(text: 'Здраво', targetLanguage: 'en');
      expect(tr.from, 'bg');
    });
  });
}
