// Renders sample text in several scripts to PNG files, then runs the real
// ML Kit readers on the emulator, in Auto mode and with the chosen script.
// Logging only: results are printed as "OCR ..." lines, nothing here fails.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/services/scan_scripts.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

Future<String> _render(String text, String name) async {
  final ui.PictureRecorder rec = ui.PictureRecorder();
  final Canvas canvas = Canvas(rec);
  const double w = 1400, h = 320;
  canvas.drawRect(const Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFFFFFFF));
  final TextPainter tp = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(fontSize: 80, color: Color(0xFF000000)),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: w - 80);
  tp.paint(canvas, const Offset(40, 90));
  final ui.Image img = await rec.endRecording().toImage(w.toInt(), h.toInt());
  final ByteData? bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  final Directory dir = await getTemporaryDirectory();
  final File f = File('${dir.path}/$name.png');
  await f.writeAsBytes(bytes!.buffer.asUint8List());
  return f.path;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OCR readers on rendered samples', (WidgetTester t) async {
    const Map<String, List<String>> samples = <String, List<String>>{
      // name: [text, language code to choose as source]
      'latin': <String>['Hello world, good morning', 'en'],
      'japanese': <String>['こんにちは世界 ありがとう', 'ja'],
      'chinese': <String>['你好世界 谢谢你', 'zh'],
      'korean': <String>['안녕하세요 감사합니다', 'ko'],
      'hindi': <String>['नमस्ते दुनिया धन्यवाद', 'hi'],
      'tamil': <String>['வணக்கம் உலகம்', 'ta'],
      'russian': <String>['Привет мир, доброе утро', 'ru'],
    };
    final TextRecognizerService svc = TextRecognizerService();
    for (final MapEntry<String, List<String>> e in samples.entries) {
      try {
        final String path = await _render(e.value[0], e.key);
        final InputImage image = InputImage.fromFilePath(path);
        final Stopwatch sw = Stopwatch()..start();
        final RecognizedText auto = await svc.recognize(image);
        _log('OCR ${e.key} AUTO (${sw.elapsedMilliseconds} ms): '
            '"${auto.text.replaceAll('\n', ' ')}"');
        final TextRecognitionScript? sc = scanScriptFor(e.value[1]);
        if (sc == null) {
          _log('OCR ${e.key} CHOSEN: no reader (type-only language)');
        } else {
          sw.reset();
          final RecognizedText r = await svc.recognize(image, script: sc);
          _log('OCR ${e.key} CHOSEN ${sc.name} (${sw.elapsedMilliseconds} ms): '
              '"${r.text.replaceAll('\n', ' ')}"');
        }
      } catch (err) {
        _log('OCR ${e.key} ERROR: $err');
      }
    }
    svc.dispose();
  });
}
