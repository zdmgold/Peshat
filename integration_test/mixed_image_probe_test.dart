// Realistic mixed-script photos (signs, menus, notices; clean and
// phone-degraded). Per image: what every reader returns with its confidence,
// and what Auto finally gives. Logs "MIXIMG" lines; nothing here fails.
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/models/scan_state.dart';
import 'package:peshat/core/providers/scan_provider.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';

import 'mixed_images.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mixed-script photos', (WidgetTester t) async {
    final Directory dir = await getTemporaryDirectory();
    for (final MapEntry<String, String> e in kMixedImages.entries) {
      final File f = File('${dir.path}/mix_${e.key}.jpg')
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
          _log('MIXIMG ${e.key} reader=${s.name} conf=${TextRecognizerService.readingConfidence(got)?.toStringAsFixed(2)} '
              'foreignConf=${TextRecognizerService.readingConfidence(got, foreignOnly: true)?.toStringAsFixed(2)} '
              'text="${got.text.replaceAll('\n', ' | ')}"');
        } catch (err) {
          _log('MIXIMG ${e.key} reader=${s.name} ERROR $err');
        }
        await r.close();
      }
      final ScanProvider p = ScanProvider();
      await p
          .runImagePipeline(image: XFile(f.path), targetLanguage: 'en')
          .timeout(const Duration(minutes: 5), onTimeout: () {});
      final ScanState st = p.value;
      _log('MIXIMG ${e.key} AUTO: ${st is ScanDone ? 'src=${st.sourceLanguage} "${st.sourceText.replaceAll('\n', ' | ')}" -> "${st.translatedText.replaceAll('\n', ' | ')}"' : (st is ScanError ? 'ERROR ${st.code.name}' : st.runtimeType)}');
      p.dispose();
    }
  });
}
