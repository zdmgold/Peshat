// Calibration: how confident is ML Kit language identification on real text
// versus on the look-alike garbage the Latin reader returns for other scripts?
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:integration_test/integration_test.dart';

import 'langid_corpus.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('language id confidence', (WidgetTester t) async {
    final LanguageIdentifier id = LanguageIdentifier(confidenceThreshold: 0.01);
    Future<void> run(String label, List<String> items) async {
      for (final String s in items) {
        try {
          final List<IdentifiedLanguage> r = await id.identifyPossibleLanguages(s);
          final String top = r.isEmpty
              ? 'none'
              : '${r.first.languageTag}=${r.first.confidence.toStringAsFixed(2)}';
          _log('LID $label top=$top len=${s.length} "$s"');
        } catch (e) {
          _log('LID $label ERROR $e "$s"');
        }
      }
    }
    await run('GARBAGE', kGarbage);
    await run('REAL', kRealLatin);
    id.close();
  });
}
