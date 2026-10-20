// Exports each non-Latin sample the way the Result screen does: Indic and Thai
// as full-page images, everything else through the pdf package. Fonts come from
// the live website, so this also tests that hosting. Logs "PDF" lines, plus a
// reduced first page ("PDFIMG") for the image-based scripts.
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:peshat/core/services/pdf_fonts.dart';
import 'package:peshat/core/services/pdf_raster.dart';

import 'samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PDF export per script', (WidgetTester t) async {
    for (final MapEntry<String, List<String>> e in kSamples.entries) {
      final String text = List<String>.filled(4, e.value[1]).join('\n');
      final String tag = '${e.key} ${e.value[0]}';
      try {
        final Set<PdfScript> scripts = PdfFonts.scriptsIn(text);
        final bool rtl = PdfFonts.isMostlyRtl(text);
        final Stopwatch sw = Stopwatch()..start();
        if (PdfFonts.needsRaster(scripts)) {
          final List<Uint8List> pages =
              await PdfRaster.pages(text, scripts, rtl: rtl);
          final pw.Document doc = pw.Document();
          for (final Uint8List bytes in pages) {
            final pw.MemoryImage image = pw.MemoryImage(bytes);
            doc.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.zero,
              build: (pw.Context ctx) => pw.Image(image, fit: pw.BoxFit.fill),
            ));
          }
          final int size = (await doc.save()).length;
          _log('PDF $tag scripts=${scripts.map((PdfScript s) => s.name).join('+')} '
              'RASTER pages=${pages.length} pdfBytes=$size rtl=$rtl ms=${sw.elapsedMilliseconds}');
          final ui.Codec codec =
              await ui.instantiateImageCodec(pages.first, targetWidth: 420);
          final ui.FrameInfo frame = await codec.getNextFrame();
          final ByteData data = (await frame.image
              .toByteData(format: ui.ImageByteFormat.png))!;
          _log('PDFIMG ${e.key} ${base64Encode(data.buffer.asUint8List())}');
        } else {
          final pw.ThemeData theme = await PdfFonts.themeFor(scripts);
          final pw.Document doc = pw.Document()
            ..addPage(pw.MultiPage(
              theme: theme,
              pageFormat: PdfPageFormat.a4,
              textDirection: rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              build: (pw.Context ctx) => <pw.Widget>[
                pw.Paragraph(text: text, style: const pw.TextStyle(fontSize: 12)),
              ],
            ));
          final int size = (await doc.save()).length;
          _log('PDF $tag scripts=${scripts.map((PdfScript s) => s.name).join('+')} '
              'TEXT pdfBytes=$size rtl=$rtl ms=${sw.elapsedMilliseconds}');
        }
      } catch (err) {
        _log('PDF $tag ERROR $err');
      }
    }
  });
}
