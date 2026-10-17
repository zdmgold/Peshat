import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'pdf_fonts.dart';

/// Draws text as A4 page images using Flutter's own text engine, which joins
/// and positions letters correctly in Indic and Thai writing. The `pdf`
/// package can't, so PDFs in those scripts embed these pages instead.
class PdfRaster {
  static const _pageW = 595.0;
  static const _pageH = 842.0;
  static const _margin = 40.0;
  static const _scale = 2.5;
  static const _fontSize = 12.0;
  static final _loaded = <String>{};

  static Future<List<Uint8List>> pages(
    String text,
    Set<PdfScript> scripts, {
    required bool rtl,
  }) async {
    final fonts = await PdfFonts.fontBytes(scripts);
    for (final e in fonts.entries) {
      if (_loaded.add(e.key)) {
        final loader = FontLoader(e.key)
          ..addFont(Future.value(ByteData.sublistView(e.value)));
        await loader.load();
      }
    }
    final fallback = fonts.keys.where((k) => k != 'PeshatPdf-base').toList();
    const cw = (_pageW - 2 * _margin) * _scale;
    const ch = (_pageH - 2 * _margin) * _scale;
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'PeshatPdf-base',
          fontFamilyFallback: fallback,
          fontSize: _fontSize * _scale,
          height: 1.6,
          color: const Color(0xFF000000),
        ),
      ),
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    )..layout(maxWidth: cw);

    // Split at line boundaries so no line is cut between pages.
    final ranges = <List<double>>[];
    var start = 0.0, y = 0.0;
    for (final m in tp.computeLineMetrics()) {
      if (y + m.height - start > ch && y > start) {
        ranges.add([start, y]);
        start = y;
      }
      y += m.height;
    }
    ranges.add([start, y]);

    final out = <Uint8List>[];
    for (final r in ranges) {
      final recorder = ui.PictureRecorder();
      const w = _pageW * _scale;
      const h = _pageH * _scale;
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, w, h));
      canvas.drawRect(
          const Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFFFFFFF));
      canvas.translate(_margin * _scale, _margin * _scale);
      canvas.clipRect(Rect.fromLTWH(0, 0, cw, r[1] - r[0]));
      canvas.translate(0, -r[0]);
      tp.paint(canvas, Offset.zero);
      final picture = recorder.endRecording();
      final image = await picture.toImage(w.round(), h.round());
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      picture.dispose();
      out.add(data!.buffer.asUint8List());
    }
    tp.dispose();
    return out;
  }
}
