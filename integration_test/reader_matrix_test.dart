// Runs ALL five readers on each rendered sample and logs, per reader: text,
// line count, mean line confidence and the languages ML Kit reports. Used to
// find a signal that tells a correct reading from a look-alike one.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

Future<String> _render(String text, String name, {required bool hard}) async {
  final ui.PictureRecorder rec = ui.PictureRecorder();
  final Canvas canvas = Canvas(rec);
  const double w = 1400, h = 360;
  canvas.drawRect(const Rect.fromLTWH(0, 0, w, h),
      Paint()..color = hard ? const Color(0xFFDADADA) : const Color(0xFFFFFFFF));
  final TextPainter tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
          fontSize: hard ? 38 : 80,
          color: hard ? const Color(0xFF666666) : const Color(0xFF000000)),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: w - 80);
  if (hard) {
    canvas.translate(60, 120);
    canvas.rotate(3 * math.pi / 180);
    tp.paint(canvas, Offset.zero);
  } else {
    tp.paint(canvas, const Offset(40, 90));
  }
  final ui.Image img = await rec.endRecording().toImage(w.toInt(), h.toInt());
  final ByteData? bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  final Directory dir = await getTemporaryDirectory();
  final File f = File('${dir.path}/$name.png');
  await f.writeAsBytes(bytes!.buffer.asUint8List());
  return f.path;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reader matrix', (WidgetTester t) async {
    final Map<String, String> all = <String, String>{
      for (final MapEntry<String, List<String>> e in kSamples.entries) e.key: e.value[1],
      'en': 'Good morning, how are you today?',
      'fr': 'Où est la gare, s\'il vous plaît ?',
      'de': 'Der Zug nach Berlin fährt um 14 Uhr',
      'es': '¿Cuánto cuesta el baño? Está al fondo.',
    };
    final Map<TextRecognitionScript, TextRecognizer> readers =
        <TextRecognitionScript, TextRecognizer>{
      for (final TextRecognitionScript s in TextRecognitionScript.values)
        s: TextRecognizer(script: s),
    };
    for (final bool hard in <bool>[false, true]) {
      for (final MapEntry<String, String> e in all.entries) {
        final String path =
            await _render(e.value, 'm_${e.key}_${hard ? 'h' : 'c'}', hard: hard);
        final InputImage image = InputImage.fromFilePath(path);
        for (final MapEntry<TextRecognitionScript, TextRecognizer> r in readers.entries) {
          try {
            final Stopwatch sw = Stopwatch()..start();
            final RecognizedText res = await r.value.processImage(image);
            final List<TextLine> lines = <TextLine>[
              for (final TextBlock b in res.blocks) ...b.lines,
            ];
            final List<double> confs = <double>[
              for (final TextLine l in lines)
                if (l.confidence != null) l.confidence!,
            ];
            final String mean = confs.isEmpty
                ? 'n/a'
                : (confs.reduce((double a, double b) => a + b) / confs.length)
                    .toStringAsFixed(2);
            final Set<String> langs = <String>{
              for (final TextLine l in lines) ...l.recognizedLanguages,
            };
            _log('MX ${e.key} ${hard ? 'HARD' : 'clean'} ${r.key.name} '
                'lines=${lines.length} conf=$mean langs=${langs.join('+')} '
                'ms=${sw.elapsedMilliseconds} text="${res.text.replaceAll('\n', ' ')}"');
          } catch (err) {
            _log('MX ${e.key} ${hard ? 'HARD' : 'clean'} ${r.key.name} ERROR $err');
          }
        }
      }
    }
    for (final TextRecognizer r in readers.values) {
      await r.close();
    }
  });
}
