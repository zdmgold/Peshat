// Renders each non-Latin sentence to an image (clean and "hard": small, grey,
// slightly rotated), then runs the real ML Kit readers in Auto mode and with
// the chosen script. Logs "OCR" lines with a match score; nothing here fails.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/services/scan_scripts.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';

import 'samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

String _norm(String s) =>
    s.replaceAll(RegExp(r'[\s\p{P}\p{S}]', unicode: true), '').toLowerCase();

/// 0-100: how much of [want] is present in [got] (edit distance based).
int _score(String want, String got) {
  final List<int> a = _norm(want).runes.toList();
  final List<int> b = _norm(got).runes.toList();
  if (a.isEmpty) return 0;
  List<int> prev = List<int>.generate(b.length + 1, (int i) => i);
  for (int i = 1; i <= a.length; i++) {
    final List<int> cur = List<int>.filled(b.length + 1, 0);
    cur[0] = i;
    for (int j = 1; j <= b.length; j++) {
      final int cost = a[i - 1] == b[j - 1] ? 0 : 1;
      cur[j] = math.min(math.min(cur[j - 1] + 1, prev[j] + 1), prev[j - 1] + cost);
    }
    prev = cur;
  }
  final double d = prev[b.length] / a.length;
  return ((1 - d).clamp(0.0, 1.0) * 100).round();
}

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

  testWidgets('OCR readers on rendered samples', (WidgetTester t) async {
    final TextRecognizerService svc = TextRecognizerService();
    for (final bool hard in <bool>[false, true]) {
      for (final MapEntry<String, List<String>> e in kSamples.entries) {
        final String code = e.key;
        final String tag = '$code ${e.value[0]} ${hard ? 'HARD' : 'clean'}';
        try {
          final String path = await _render(e.value[1], '${code}_${hard ? 'h' : 'c'}', hard: hard);
          final InputImage image = InputImage.fromFilePath(path);
          final Stopwatch sw = Stopwatch()..start();
          final String auto = (await svc.recognize(image)).text.replaceAll('\n', ' ');
          _log('OCR $tag AUTO score=${_score(e.value[1], auto)} (${sw.elapsedMilliseconds} ms): "$auto"');
          final TextRecognitionScript? sc = scanScriptFor(code);
          if (sc == null) {
            _log('OCR $tag CHOSEN none (type-only language)');
          } else {
            sw.reset();
            final String got = (await svc.recognize(image, script: sc)).text.replaceAll('\n', ' ');
            _log('OCR $tag CHOSEN ${sc.name} score=${_score(e.value[1], got)} (${sw.elapsedMilliseconds} ms): "$got"');
          }
        } catch (err) {
          _log('OCR $tag ERROR: $err');
        }
      }
    }
    svc.dispose();
  });
}
