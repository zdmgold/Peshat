// The exact images and texts the user was given for phone testing, run on the
// emulator through the real pipeline (ScanProvider): Auto and chosen source.
// Logs "USER" lines; nothing here fails.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/language_detector.dart';

import 'samples.dart';
import 'user_images.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

String _describe(ScanState s) {
  if (s is ScanDone) {
    return 'DONE src=${s.sourceLanguage} same=${s.sameLanguage} '
        'text="${s.sourceText.replaceAll('\n', ' ')}" -> "${s.translatedText.replaceAll('\n', ' ')}"';
  }
  if (s is ScanError) return 'ERROR ${s.code.name} ${s.detail ?? ''}'.replaceAll('\n', ' ');
  return s.runtimeType.toString();
}

Future<ScanState> _finish(ScanProvider p, Future<void> run) async {
  await run.timeout(const Duration(minutes: 5), onTimeout: () {});
  return p.value;
}

const List<String> kTyped = <String>[
  'Hello दोस्त, how are you? आज मौसम अच्छा है।',
  'नमस्ते',
  'Привет',
  'مرحبا',
  'こんにちは',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user sample images', (WidgetTester t) async {
    final Directory dir = await getTemporaryDirectory();
    for (final MapEntry<String, String> e in kUserImages.entries) {
      final File f = File('${dir.path}/user_${e.key}.png')
        ..writeAsBytesSync(base64Decode(e.value));
      for (final String mode in <String>['auto', e.key]) {
        final ScanProvider p = ScanProvider();
        final ScanState s = await _finish(
            p,
            p.runImagePipeline(
                image: XFile(f.path),
                targetLanguage: 'en',
                sourceLanguage: mode));
        _log('USER image ${e.key} source=$mode: ${_describe(s)}');
        p.dispose();
      }
    }
  });

  testWidgets('user typed texts', (WidgetTester t) async {
    final LanguageDetector det = LanguageDetector();
    final List<String> typed = <String>[
      ...kTyped,
      for (final List<String> v in kSamples.values) v[1],
    ];
    for (final String text in typed) {
      String raw = '?';
      try {
        raw = await det.detect(text);
      } catch (e) {
        raw = 'ERR $e';
      }
      _log('USER detect "$text" -> $raw');
    }
    for (final MapEntry<String, List<String>> e in kSamples.entries) {
      for (final String mode in <String>['auto', e.key]) {
        final ScanProvider p = ScanProvider();
        final ScanState s = await _finish(
            p,
            p.runTextPipeline(
                text: e.value[1], targetLanguage: 'en', sourceLanguage: mode));
        _log('USER typed ${e.key} source=$mode: ${_describe(s)}');
        p.dispose();
      }
    }
    for (final String text in kTyped) {
      for (final String mode in <String>['auto', 'hi', 'en', 'ru', 'ar', 'ja']) {
        final ScanProvider p = ScanProvider();
        final ScanState s = await _finish(
            p,
            p.runTextPipeline(
                text: text, targetLanguage: 'en', sourceLanguage: mode));
        _log('USER typed-extra "$text" source=$mode: ${_describe(s)}');
        p.dispose();
      }
    }
    det.dispose();
  });
}
