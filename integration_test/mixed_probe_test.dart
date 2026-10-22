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
import 'package:peshat/core/services/translator_service.dart';

import 'mixed_cases.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

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
        core = await det.detect(text.replaceAll(RegExp(r'[A-Za-z0-9 ,.!?]+'), ' ').trim());
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
