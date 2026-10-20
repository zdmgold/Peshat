// Latin-script coverage: renders each Latin language's sentence (clean and
// hard) and runs the real Auto reader, then checks typed-text detection for
// every Latin language, then awkward text shapes. Logs only.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/services/language_detector.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';

import 'latin_samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

String _norm(String s) =>
    s.replaceAll(RegExp(r'[\s\p{P}\p{S}]', unicode: true), '').toLowerCase();

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
  return ((1 - prev[b.length] / a.length).clamp(0.0, 1.0) * 100).round();
}

Future<String> _render(String text, String name, {required bool hard}) async {
  final ui.PictureRecorder rec = ui.PictureRecorder();
  final Canvas canvas = Canvas(rec);
  const double w = 1400, h = 420;
  canvas.drawRect(const Rect.fromLTWH(0, 0, w, h),
      Paint()..color = hard ? const Color(0xFFDADADA) : const Color(0xFFFFFFFF));
  final TextPainter tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
          fontSize: hard ? 38 : 70,
          color: hard ? const Color(0xFF666666) : const Color(0xFF000000)),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: w - 80);
  if (hard) {
    canvas.translate(60, 120);
    canvas.rotate(3 * math.pi / 180);
    tp.paint(canvas, Offset.zero);
  } else {
    tp.paint(canvas, const Offset(40, 60));
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

  testWidgets('Latin coverage', (WidgetTester t) async {
    final TextRecognizerService svc = TextRecognizerService();
    final LanguageDetector det = LanguageDetector();

    // 1. Typed detection for every Latin language.
    for (final MapEntry<String, List<String>> e in kLatinSamples.entries) {
      try {
        final String d = await det.detect(e.value[1]);
        _log('LAT typed ${e.key} ${e.value[0]} detected=$d ${d == e.key ? 'OK' : 'WRONG'}');
      } catch (err) {
        _log('LAT typed ${e.key} ERROR $err');
      }
    }

    // 2. Auto reading of rendered images.
    for (final bool hard in <bool>[false, true]) {
      for (final MapEntry<String, List<String>> e in kLatinSamples.entries) {
        final String tag = '${e.key} ${e.value[0]} ${hard ? 'HARD' : 'clean'}';
        try {
          final String path = await _render(e.value[1], 'l_${e.key}_${hard ? 'h' : 'c'}', hard: hard);
          final Stopwatch sw = Stopwatch()..start();
          final String got = (await svc.recognize(InputImage.fromFilePath(path)))
              .text
              .replaceAll('\n', ' ');
          _log('LAT img $tag AUTO score=${_score(e.value[1], got)} (${sw.elapsedMilliseconds} ms): "$got"');
        } catch (err) {
          _log('LAT img $tag ERROR $err');
        }
      }
    }

    // 3. Awkward shapes.
    for (final bool hard in <bool>[false, true]) {
      for (final MapEntry<String, String> e in kShapes.entries) {
        final String tag = 'shape ${e.key} ${hard ? 'HARD' : 'clean'}';
        try {
          final String path = await _render(e.value, 's_${e.key}_${hard ? 'h' : 'c'}', hard: hard);
          final String got = (await svc.recognize(InputImage.fromFilePath(path)))
              .text
              .replaceAll('\n', ' | ');
          _log('LAT $tag AUTO score=${_score(e.value, got)}: want "${e.value.replaceAll('\n', ' | ')}" got "$got"');
        } catch (err) {
          _log('LAT $tag ERROR $err');
        }
      }
    }
    svc.dispose();
    det.dispose();
  });
}
