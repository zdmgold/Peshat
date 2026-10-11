import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/pdf_fonts.dart';

void main() {
  test('detects the extra scripts a text needs', () {
    expect(PdfFonts.scriptsIn('Hello Привет Γειά'), isEmpty);
    expect(PdfFonts.scriptsIn('مرحبا'), {PdfScript.arabic});
    expect(PdfFonts.scriptsIn('שלום'), {PdfScript.hebrew});
    expect(PdfFonts.scriptsIn('สวัสดี'), {PdfScript.thai});
    expect(PdfFonts.scriptsIn('नमस्ते'), {PdfScript.devanagari});
    expect(PdfFonts.scriptsIn('你好'), {PdfScript.chineseHan});
    expect(PdfFonts.scriptsIn('日本語のテキスト'), {PdfScript.japanese});
    expect(PdfFonts.scriptsIn('안녕하세요'), {PdfScript.korean});
  });

  test('right-to-left detection', () {
    expect(PdfFonts.isMostlyRtl('مرحبا بالعالم'), isTrue);
    expect(PdfFonts.isMostlyRtl('Hello world'), isFalse);
  });
}
