// Realistic mixed-language text: which source language gives the best
// translation? For each case: detection on the whole text and on the foreign
// words, then translation from the foreign model, from English, and what Auto
// does today. Logs "MIX" lines; nothing here fails.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/text_quality.dart';
import 'package:peshat/core/services/translator_service.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

// kind: E = English with a short foreign phrase, F = foreign sentence with
// English words, B = balanced. [kind, foreign code, text]
const List<List<String>> kMixed = <List<String>>[
  ['E', 'hi', 'She replied नमस्ते with a smile and walked into the room.'],
  ['E', 'hi', 'The shop sign says दुकान बंद है today, so we went home.'],
  ['E', 'zh', 'The sign at the entrance says 早上好 which means good morning.'],
  ['E', 'zh', 'Please ask for 麻婆豆腐 when you order at the restaurant.'],
  ['E', 'ja', 'The menu lists ラーメン and 餃子 for lunch today.'],
  ['E', 'ja', 'I learned the word ありがとう from my Japanese teacher yesterday.'],
  ['E', 'ko', 'My friend said 안녕하세요 when we met at the station.'],
  ['E', 'ru', 'My Russian friend always says Привет when he calls me.'],
  ['E', 'ar', 'He greeted us with مرحبا and offered some tea.'],
  ['E', 'th', 'The waiter said สวัสดี and showed us to the table.'],
  ['F', 'hi', 'आज मैं office जा रहा हूँ और मेरी meeting दस बजे है।'],
  ['F', 'hi', 'मुझे यह phone बहुत पसंद है, battery भी अच्छी है।'],
  ['F', 'hi', 'कृपया WiFi password reception से पूछें।'],
  ['F', 'ru', 'Я вчера купил новый iPhone в магазине.'],
  ['F', 'ru', 'Пожалуйста, введите ваш password и email.'],
  ['F', 'ja', '今日は午後三時からMeetingがあります。'],
  ['F', 'ja', 'このレストランのWiFiパスワードを教えてください。'],
  ['F', 'zh', '我喜欢用iPhone拍照，也常用WeChat聊天。'],
  ['F', 'zh', '请在前台询问WiFi密码。'],
  ['F', 'ko', '오늘 오후에 meeting이 있어요.'],
  ['F', 'ar', 'اشتريت iPhone جديد أمس من المتجر.'],
  ['F', 'th', 'วันนี้ฉันมี meeting ตอนบ่ายสามโมง'],
  ['F', 'bn', 'আমি আজ office যাচ্ছি এবং meeting আছে।'],
  ['B', 'hi', 'Hello दोस्त, how are you? आज मौसम अच्छा है।'],
  ['B', 'ja', 'Hello 友達、元気ですか? How are you today?'],
  ['B', 'zh', 'Good morning 朋友，你今天好吗? See you soon.'],
  ['B', 'ru', 'Hello друг, как дела? I hope you are fine.'],
];

Future<String> _tr(TranslatorService svc, String text, String from, String to) async {
  try {
    for (final String c in await svc.missingPacks(fromBcp: from, toBcp: to)) {
      await svc.receivePack(c).timeout(const Duration(seconds: 150));
    }
    return (await svc
            .translate(text: text, fromBcp: from, toBcp: to)
            .timeout(const Duration(seconds: 60)))
        .replaceAll('\n', ' ');
  } catch (e) {
    return 'ERROR($e)';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mixed-language text', (WidgetTester t) async {
    final LanguageDetector det = LanguageDetector();
    final TranslatorService svc = TranslatorService();
    for (final List<String> c in kMixed) {
      final String kind = c[0], code = c[1], text = c[2];
      String whole = '?', core = '-';
      try {
        whole = await det.detect(text);
        final String? fc = TextQuality.foreignCore(text);
        if (fc != null) core = await det.detect(fc);
      } catch (e) {
        whole = 'ERR';
      }
      _log('MIX $kind $code detect whole=$whole core=$core | "$text"');
      _log('MIX $kind $code foreign-model(->en): "${await _tr(svc, text, code, 'en')}"');
      _log('MIX $kind $code english-model(->en): "${await _tr(svc, text, 'en', 'en')}"');
      for (final String to in <String>['fr', 'de']) {
        _log('MIX $kind $code ->$to foreign-model: "${await _tr(svc, text, code, to)}"');
        _log('MIX $kind $code ->$to english-model: "${await _tr(svc, text, 'en', to)}"');
        final ScanProvider p = ScanProvider();
        await p
            .runTextPipeline(text: text, targetLanguage: to)
            .timeout(const Duration(minutes: 5), onTimeout: () {});
        final ScanState s = p.value;
        _log('MIX $kind $code ->$to auto: ${s is ScanDone ? 'src=${s.sourceLanguage} "${s.translatedText.replaceAll('\n', ' ')}"' : s.runtimeType}');
        p.dispose();
      }
      final ScanProvider p = ScanProvider();
      await p
          .runTextPipeline(text: text, targetLanguage: 'en')
          .timeout(const Duration(minutes: 5), onTimeout: () {});
      final ScanState s = p.value;
      _log('MIX $kind $code ->en auto: ${s is ScanDone ? 'src=${s.sourceLanguage} "${s.translatedText.replaceAll('\n', ' ')}"' : s.runtimeType}');
      p.dispose();
    }
    det.dispose();
  });
}
