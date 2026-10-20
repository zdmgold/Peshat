// Simulated phone photos: the same sentences with blur, noise, low resolution,
// perspective, uneven light, and a combined "phone" look, read in Auto mode by
// the real readers. Logs "PHOTO" lines with a match score. Nothing fails.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peshat/core/services/text_recognizer_service.dart';

import 'latin_samples.dart';
import 'samples.dart';

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

const double _w = 1400, _h = 420;

void _paper(Canvas c, Color paper) =>
    c.drawRect(const Rect.fromLTWH(0, 0, _w, _h), Paint()..color = paper);

TextPainter _text(String text, double size, Color color) => TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size, color: color)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _w - 120);

void _noise(Canvas c, int dots, double alpha) {
  final math.Random r = math.Random(7);
  final Paint p = Paint()..color = Color.fromRGBO(60, 60, 60, alpha);
  for (int i = 0; i < dots; i++) {
    c.drawCircle(Offset(r.nextDouble() * _w, r.nextDouble() * _h), 1.2 + r.nextDouble() * 1.4, p);
  }
}

void _shade(Canvas c) {
  c.drawRect(
      const Rect.fromLTWH(0, 0, _w, _h),
      Paint()
        ..shader = ui.Gradient.linear(const Offset(0, 0), const Offset(_w, _h),
            <Color>[const Color(0x00000000), const Color(0x99000000)]));
}

Future<String> _render(String text, String name, String mode) async {
  final ui.PictureRecorder rec = ui.PictureRecorder();
  final Canvas c = Canvas(rec);
  final bool phone = mode == 'phone';
  _paper(c, phone ? const Color(0xFFF1E9D6) : const Color(0xFFFFFFFF));
  final TextPainter tp = _text(text, phone ? 46 : 60, const Color(0xFF222222));
  switch (mode) {
    case 'blur':
      c.saveLayer(const Rect.fromLTWH(0, 0, _w, _h),
          Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 2.4, sigmaY: 2.4));
      tp.paint(c, const Offset(60, 100));
      c.restore();
    case 'noise':
      tp.paint(c, const Offset(60, 100));
      _noise(c, 3500, 0.4);
    case 'skew':
      c.translate(_w / 2, _h / 2);
      c.transform((Matrix4.identity()
            ..setEntry(3, 2, 0.0009)
            ..rotateY(0.45)
            ..rotateZ(0.05))
          .storage);
      c.translate(-_w / 2, -_h / 2);
      tp.paint(c, const Offset(60, 100));
    case 'light':
      tp.paint(c, const Offset(60, 100));
      _shade(c);
    case 'phone':
      c.translate(80, 90);
      c.rotate(4 * math.pi / 180);
      c.saveLayer(const Rect.fromLTWH(-80, -90, _w, _h + 200),
          Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 1.1, sigmaY: 1.1));
      tp.paint(c, Offset.zero);
      c.restore();
      c.rotate(-4 * math.pi / 180);
      c.translate(-80, -90);
      _noise(c, 2500, 0.3);
      _shade(c);
    default: // lowres drawn normally, shrunk below
      tp.paint(c, const Offset(60, 100));
  }
  ui.Image img = await rec.endRecording().toImage(_w.toInt(), _h.toInt());
  if (mode == 'lowres') {
    final ui.PictureRecorder r2 = ui.PictureRecorder();
    final Canvas c2 = Canvas(r2);
    c2.drawImageRect(img, const Rect.fromLTWH(0, 0, _w, _h),
        const Rect.fromLTWH(0, 0, 420, 126), Paint()..filterQuality = FilterQuality.low);
    img = await r2.endRecording().toImage(420, 126);
  }
  final ByteData? bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  final Directory dir = await getTemporaryDirectory();
  final File f = File('${dir.path}/$name.png');
  await f.writeAsBytes(bytes!.buffer.asUint8List());
  return f.path;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('simulated phone photos', (WidgetTester t) async {
    final TextRecognizerService svc = TextRecognizerService();
    const List<String> latin = <String>['en', 'fr', 'de', 'es', 'tr', 'vi', 'pl', 'fi'];
    const List<String> readable = <String>['hi', 'mr', 'bn', 'zh', 'ja', 'ko'];
    const List<String> typeOnly = <String>['ru', 'ar', 'th', 'ta', 'he', 'el', 'ka'];
    final Map<String, String> text = <String, String>{
      for (final String c in latin) c: kLatinSamples[c]![1],
      for (final String c in <String>[...readable, ...typeOnly]) c: kSamples[c]![1],
    };
    for (final String mode in <String>['phone', 'blur', 'noise', 'lowres', 'skew', 'light']) {
      for (final String group in <String>['latin', 'readable', 'typeonly']) {
        final List<String> codes =
            group == 'latin' ? latin : (group == 'readable' ? readable : typeOnly);
        for (final String code in codes) {
          final String tag = '$group $code $mode';
          try {
            final String path = await _render(text[code]!, 'p_${code}_$mode', mode);
            final Stopwatch sw = Stopwatch()..start();
            final String got = (await svc.recognize(InputImage.fromFilePath(path)))
                .text
                .replaceAll('\n', ' ');
            _log('PHOTO $tag score=${_score(text[code]!, got)} (${sw.elapsedMilliseconds} ms): "$got"');
          } catch (err) {
            _log('PHOTO $tag ERROR $err');
          }
        }
      }
    }
    svc.dispose();
  });
}
