// What does each reader report per line and per word on mixed photos: text,
// confidence and the language/script the reader itself assigns. Logs "RD"
// lines; nothing here fails.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'mixed_images.dart';
import 'user_images.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reader detail', (WidgetTester t) async {
    final Directory dir = await getTemporaryDirectory();
    final Map<String, String> all = <String, String>{
      for (final MapEntry<String, String> e in kMixedImages.entries)
        if (e.key.endsWith('_phone')) e.key: e.value,
      for (final String k in <String>['hi', 'zh', 'ja', 'ko', 'gu', 'mr', 'bn', 'ru', 'ar'])
        'user_$k': kUserImages[k]!,
    };
    for (final MapEntry<String, String> e in all.entries) {
      final File f = File('${dir.path}/rd_${e.key}.img')
        ..writeAsBytesSync(base64Decode(e.value));
      for (final TextRecognitionScript s in <TextRecognitionScript>[
        TextRecognitionScript.latin,
        TextRecognitionScript.devanagiri,
        TextRecognitionScript.chinese,
        TextRecognitionScript.japanese,
        TextRecognitionScript.korean,
      ]) {
        final TextRecognizer r = TextRecognizer(script: s);
        try {
          final RecognizedText got =
              await r.processImage(InputImage.fromFilePath(f.path));
          for (final TextBlock b in got.blocks) {
            for (final TextLine l in b.lines) {
              final String langs = l.recognizedLanguages.join(',');
              final String els = l.elements
                  .map((TextElement el) =>
                      '${el.text}:${el.confidence?.toStringAsFixed(2)}')
                  .join(' ');
              _log('RD ${e.key} ${s.name} line conf=${l.confidence?.toStringAsFixed(2)} '
                  'langs=[$langs] "${l.text}" els=[$els]');
            }
          }
        } catch (err) {
          _log('RD ${e.key} ${s.name} ERROR $err');
        }
        await r.close();
      }
    }
  });
}
