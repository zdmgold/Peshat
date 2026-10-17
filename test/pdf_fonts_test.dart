import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/pdf_fonts.dart';

void main() {
  test('detects the extra scripts a text needs', () {
    expect(PdfFonts.scriptsIn('Hello Привет Γειά'), isEmpty);
    expect(PdfFonts.scriptsIn('مرحبا'), {PdfScript.arabic});
    expect(PdfFonts.scriptsIn('שלום'), {PdfScript.hebrew});
    expect(PdfFonts.scriptsIn('สวัสดี'), {PdfScript.thai});
    expect(PdfFonts.scriptsIn('नमस्ते'), {PdfScript.devanagari});
    expect(PdfFonts.scriptsIn('বাংলা'), {PdfScript.bengali});
    expect(PdfFonts.scriptsIn('ગુજરાતી'), {PdfScript.gujarati});
    expect(PdfFonts.scriptsIn('ಕನ್ನಡ'), {PdfScript.kannada});
    expect(PdfFonts.scriptsIn('தமிழ்'), {PdfScript.tamil});
    expect(PdfFonts.scriptsIn('తెలుగు'), {PdfScript.telugu});
    expect(PdfFonts.scriptsIn('ქართული'), {PdfScript.georgian});
    expect(PdfFonts.scriptsIn('你好'), {PdfScript.chineseHan});
    expect(PdfFonts.scriptsIn('日本語のテキスト'), {PdfScript.japanese});
    expect(PdfFonts.scriptsIn('안녕하세요'), {PdfScript.korean});
  });

  test('right-to-left detection', () {
    expect(PdfFonts.isMostlyRtl('مرحبا بالعالم'), isTrue);
    expect(PdfFonts.isMostlyRtl('Hello world'), isFalse);
  });

  test('letter-joining scripts are drawn as images, others stay text', () {
    for (final t in ['हिन्दी', 'বাংলা', 'ગુજરાતી', 'ಕನ್ನಡ', 'தமிழ்', 'తెలుగు', 'ไทย']) {
      expect(PdfFonts.needsRaster(PdfFonts.scriptsIn(t)), isTrue, reason: t);
    }
    for (final t in ['Hello', 'مرحبا', 'שלום', 'ქართული', '你好', '日本語', '안녕']) {
      expect(PdfFonts.needsRaster(PdfFonts.scriptsIn(t)), isFalse, reason: t);
    }
  });
}
