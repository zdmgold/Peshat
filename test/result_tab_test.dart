import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';
import 'package:peshat/core/services/translator_service.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/result_screen.dart';

class _Ocr implements TextRecognizerService {
  @override
  Future<RecognizedText> recognize(InputImage image) =>
      throw UnimplementedError();
  @override
  void dispose() {}
}

class _Detector implements LanguageDetector {
  @override
  Future<String> detect(String text) async => 'es';
  @override
  void dispose() {}
}

class _Translator implements TranslatorService {
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
          required String toBcp}) async =>
      'T:$text';
}

void main() {
  for (final fromHistory in [true, false]) {
    testWidgets(
        'result opens on the Translation tab (${fromHistory ? 'from History' : 'new scan'})',
        (tester) async {
      SharedPreferences.setMockInitialValues({'ads_removed': true});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        CupertinoApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ResultScreen(
            inputText: 'hola',
            initialTargetLanguage: 'en',
            history: HistoryProvider(prefs),
            saveToHistory: !fromHistory,
            provider: ScanProvider(
              ocr: _Ocr(),
              translator: _Translator(),
              detector: _Detector(),
              internetCheck: () async => true,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      final tabs = tester
          .widgetList<IndexedStack>(find.byType(IndexedStack))
          .where((w) => w.children.length == 2)
          .toList();
      expect(tabs, isNotEmpty);
      expect(tabs.every((w) => w.index == 1), isTrue);
      expect(find.text('T:hola'), findsOneWidget);
      // One slim line: source, arrow, target.
      expect(find.text('Español'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.arrow_right), findsOneWidget);
    });
  }
}
