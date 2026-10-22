// Whole text through the foreign model versus only the foreign runs through
// theirs, over the mixed corpus. Logs "SEG" lines with the foreign share so the
// switch-over point can be read off the results. Nothing here fails.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/mixed_text.dart';
import 'package:peshat/core/services/mixed_translation.dart';
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
        .replaceAll('\n', ' | ');
  } catch (e) {
    return 'ERROR($e)';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('segmented versus whole', (WidgetTester t) async {
    final LanguageDetector det = LanguageDetector();
    final TranslatorService svc = TranslatorService();
    final MixedTranslation mt = MixedTranslation(det);
    for (final List<String> c in kMixed) {
      final String kind = c[0], code = c[1], text = c[2];
      final double share = MixedText.foreignShare(text);
      _log('SEG ${kind} ${code} share=${share.toStringAsFixed(2)} "${text.replaceAll('\n', ' | ')}"');
      _log('SEG ${kind} ${code} runs=${MixedText.split(text)}'.replaceAll('\n', '\\n'));
      for (final String to in <String>['en', 'fr']) {
        final String whole = await _tr(svc, text, code, to);
        String seg;
        String langs = '';
        try {
          final List<MixedPiece> plan = await mt.plan(text, to);
          langs = plan.map((MixedPiece p) => p.from ?? '-').join(',');
          seg = (await MixedTranslation.run(plan, to,
                  (String x, String f, String tt) => _tr(svc, x, f, tt)))
              .replaceAll('\n', ' | ');
        } catch (e) {
          seg = 'ERROR($e)';
        }
        _log('SEG $kind $code ->$to whole: "$whole"');
        _log('SEG $kind $code ->$to segmented[$langs]: "$seg"');
      }
    }
    det.dispose();
  });
}
