// Back-translation screening of the app's menu strings: every translated
// string is translated back to English on the device and logged next to the
// original English, so strings whose meaning drifted can be reviewed.
// Logs "EMU BT" lines; nothing here fails.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/services/translator_service.dart';

import 'ui_strings.dart';

void _log(String m) =>
    // ignore: avoid_print
    print('EMU BT $m');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('back-translate every menu string', (t) async {
    final svc = TranslatorService();
    final english = (kUiStrings['en'] as Map).cast<String, String>();
    final skipped = <String>[];
    var done = 0;
    for (final lang in kUiStrings.keys) {
      if (lang == 'en') continue;
      if (!TranslatorService.isTranslatable(lang)) {
        skipped.add(lang);
        continue;
      }
      final strings = (kUiStrings[lang] as Map).cast<String, String>();
      try {
        for (final c in await svc.missingPacks(fromBcp: lang, toBcp: 'en')) {
          await svc.receivePack(c).timeout(const Duration(seconds: 240));
        }
      } catch (e) {
        _log('PACKFAIL $lang $e');
        continue;
      }
      for (final e in strings.entries) {
        String back;
        try {
          back = await svc
              .translate(text: e.value, fromBcp: lang, toBcp: 'en')
              .timeout(const Duration(seconds: 60));
        } catch (err) {
          back = 'ERROR($err)';
        }
        _log('ROW\t$lang\t${e.key}\t${english[e.key]!.replaceAll('\n', ' ')}'
            '\t${back.replaceAll('\n', ' ')}');
        done++;
      }
      _log('LANGDONE $lang');
    }
    _log('SKIPPED ${skipped.join(",")}');
    _log('DONE $done');
  }, timeout: const Timeout(Duration(minutes: 85)));
}
