// Typed non-Latin text: what does language detection say for a full sentence
// and for one short word, and what does the on-device translation give (to
// English) from the detected language and from the true language?
// Logs "TYPED" lines; nothing here fails.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/translator_service.dart';

import 'samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

Future<String> _tr(TranslatorService svc, String text, String from) async {
  try {
    for (final String c in await svc.missingPacks(fromBcp: from, toBcp: 'en')) {
      await svc.receivePack(c).timeout(const Duration(seconds: 150));
    }
    return await svc
        .translate(text: text, fromBcp: from, toBcp: 'en')
        .timeout(const Duration(seconds: 60));
  } catch (e) {
    return 'ERROR($e)';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('typed text detection and translation', (WidgetTester t) async {
    final LanguageDetector det = LanguageDetector();
    final TranslatorService svc = TranslatorService();
    for (final MapEntry<String, List<String>> e in kSamples.entries) {
      final String code = e.key;
      final String name = e.value[0];
      try {
        final String dSentence = await det.detect(e.value[1]);
        final String dWord = await det.detect(e.value[2]);
        _log('TYPED $code $name detect sentence=$dSentence ${dSentence == code ? 'OK' : 'WRONG'}'
            ' | word "${e.value[2]}"=$dWord ${dWord == code ? 'OK' : 'WRONG'}');
        final String fromDetected = TranslatorService.isTranslatable(dSentence)
            ? await _tr(svc, e.value[1], dSentence)
            : 'not translatable ($dSentence)';
        _log('TYPED $code $name translate(detected=$dSentence): "$fromDetected"');
        if (dSentence != code) {
          _log('TYPED $code $name translate(true=$code): "${await _tr(svc, e.value[1], code)}"');
        }
        if (dWord != code) {
          final String w = TranslatorService.isTranslatable(dWord)
              ? await _tr(svc, e.value[2], dWord)
              : 'not translatable ($dWord)';
          _log('TYPED $code $name word translate(detected=$dWord): "$w"'
              ' | true: "${await _tr(svc, e.value[2], code)}"');
        }
      } catch (err) {
        _log('TYPED $code $name ERROR: $err');
      }
    }
    det.dispose();
  });
}
