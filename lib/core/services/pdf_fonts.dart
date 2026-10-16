import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontDownloadException implements Exception {
  final String? detail;
  PdfFontDownloadException([this.detail]);
  @override
  String toString() => 'PdfFontDownloadException($detail)';
}

enum PdfScript {
  arabic,
  hebrew,
  thai,
  devanagari,
  bengali,
  gujarati,
  kannada,
  tamil,
  telugu,
  georgian,
  chineseHan,
  japanese,
  korean,
}

/// Fonts for PDF export. Latin, Cyrillic and Greek plus Arabic, Hebrew, Thai
/// and Devanagari are bundled in the app; the Bengali, Gujarati, Kannada,
/// Tamil, Telugu, Georgian, Chinese, Japanese and Korean fonts are received
/// once from the Peshat website and cached.
class PdfFonts {
  static const baseUrl = 'https://peshat.zdmgold.workers.dev/fonts/';
  static const _baseAsset = 'assets/fonts/NotoSans-Regular.ttf';
  static const _minBytes = 40000;

  static const _bundled = <PdfScript, String>{
    PdfScript.arabic: 'assets/fonts/NotoSansArabic-Regular.ttf',
    PdfScript.hebrew: 'assets/fonts/NotoSansHebrew-Regular.ttf',
    PdfScript.thai: 'assets/fonts/NotoSansThai-Regular.ttf',
    PdfScript.devanagari: 'assets/fonts/NotoSansDevanagari-Regular.ttf',
  };

  static const _remote = <PdfScript, String>{
    PdfScript.bengali: 'NotoSansBengali-Regular.ttf',
    PdfScript.gujarati: 'NotoSansGujarati-Regular.ttf',
    PdfScript.kannada: 'NotoSansKannada-Regular.ttf',
    PdfScript.tamil: 'NotoSansTamil-Regular.ttf',
    PdfScript.telugu: 'NotoSansTelugu-Regular.ttf',
    PdfScript.georgian: 'NotoSansGeorgian-Regular.ttf',
    PdfScript.chineseHan: 'NotoSansSC-Regular.ttf',
    PdfScript.japanese: 'NotoSansJP-Regular.ttf',
    PdfScript.korean: 'NotoSansKR-Regular.ttf',
  };

  static bool _in(int c, int a, int b) => c >= a && c <= b;

  /// Which extra scripts [text] needs. Kana selects the Japanese font, Hangul
  /// the Korean one, and Han characters alone the Chinese one.
  static Set<PdfScript> scriptsIn(String text) {
    final out = <PdfScript>{};
    var kana = false, hangul = false, han = false;
    for (final c in text.runes) {
      if (_in(c, 0x0600, 0x06FF) ||
          _in(c, 0x0750, 0x077F) ||
          _in(c, 0x08A0, 0x08FF) ||
          _in(c, 0xFB50, 0xFDFF) ||
          _in(c, 0xFE70, 0xFEFF)) {
        out.add(PdfScript.arabic);
      } else if (_in(c, 0x0590, 0x05FF) || _in(c, 0xFB1D, 0xFB4F)) {
        out.add(PdfScript.hebrew);
      } else if (_in(c, 0x0E00, 0x0E7F)) {
        out.add(PdfScript.thai);
      } else if (_in(c, 0x0900, 0x097F)) {
        out.add(PdfScript.devanagari);
      } else if (_in(c, 0x0980, 0x09FF)) {
        out.add(PdfScript.bengali);
      } else if (_in(c, 0x0A80, 0x0AFF)) {
        out.add(PdfScript.gujarati);
      } else if (_in(c, 0x0B80, 0x0BFF)) {
        out.add(PdfScript.tamil);
      } else if (_in(c, 0x0C00, 0x0C7F)) {
        out.add(PdfScript.telugu);
      } else if (_in(c, 0x0C80, 0x0CFF)) {
        out.add(PdfScript.kannada);
      } else if (_in(c, 0x10A0, 0x10FF) ||
          _in(c, 0x1C90, 0x1CBF) ||
          _in(c, 0x2D00, 0x2D2F)) {
        out.add(PdfScript.georgian);
      } else if (_in(c, 0x3040, 0x30FF) || _in(c, 0x31F0, 0x31FF)) {
        kana = true;
      } else if (_in(c, 0xAC00, 0xD7AF) ||
          _in(c, 0x1100, 0x11FF) ||
          _in(c, 0x3130, 0x318F)) {
        hangul = true;
      } else if (_in(c, 0x4E00, 0x9FFF) ||
          _in(c, 0x3400, 0x4DBF) ||
          _in(c, 0xF900, 0xFAFF)) {
        han = true;
      }
    }
    if (kana) {
      out.add(PdfScript.japanese);
    } else if (hangul) {
      out.add(PdfScript.korean);
    } else if (han) {
      out.add(PdfScript.chineseHan);
    }
    return out;
  }

  /// True when most letters are right-to-left (Arabic / Hebrew).
  static bool isMostlyRtl(String text) {
    var rtl = 0, other = 0;
    for (final c in text.runes) {
      if (_in(c, 0x0590, 0x08FF) ||
          _in(c, 0xFB1D, 0xFDFF) ||
          _in(c, 0xFE70, 0xFEFF)) {
        rtl++;
      } else if (_in(c, 0x41, 0x5A) || _in(c, 0x61, 0x7A) || c > 0xFF) {
        other++;
      }
    }
    return rtl > 0 && rtl >= other;
  }

  static Future<File> _cacheFile(String name) async {
    final dir = await getApplicationSupportDirectory();
    final folder = Directory('${dir.path}/pdf_fonts');
    await folder.create(recursive: true);
    return File('${folder.path}/$name');
  }

  static Future<bool> needsDownload(Set<PdfScript> scripts) async {
    for (final s in scripts) {
      final name = _remote[s];
      if (name == null) continue;
      final f = await _cacheFile(name);
      if (!await f.exists() || await f.length() < _minBytes) return true;
    }
    return false;
  }

  static bool _looksLikeTtf(List<int> head) =>
      head.length >= 4 &&
      ((head[0] == 0 && head[1] == 1 && head[2] == 0 && head[3] == 0) ||
          (head[0] == 0x74 && head[1] == 0x72 && head[2] == 0x75 && head[3] == 0x65));

  static Future<File> _ensureDownloaded(String name) async {
    final file = await _cacheFile(name);
    if (await file.exists() && await file.length() >= _minBytes) return file;
    final tmp = File('${file.path}.part');
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);
    try {
      final req = await client
          .getUrl(Uri.parse('$baseUrl$name'))
          .timeout(const Duration(seconds: 20));
      final res = await req.close().timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) {
        throw PdfFontDownloadException('HTTP ${res.statusCode}');
      }
      final sink = tmp.openWrite();
      try {
        await sink.addStream(res).timeout(const Duration(minutes: 3));
      } finally {
        await sink.close();
      }
      final length = await tmp.length();
      final head = await tmp.openRead(0, 4).expand((b) => b).toList();
      if (length < _minBytes || !_looksLikeTtf(head)) {
        throw PdfFontDownloadException('bad font file');
      }
      await tmp.rename(file.path);
      return file;
    } catch (e) {
      try {
        if (await tmp.exists()) await tmp.delete();
      } catch (_) {}
      if (e is PdfFontDownloadException) rethrow;
      throw PdfFontDownloadException(e.toString());
    } finally {
      client.close(force: true);
    }
  }

  /// Builds the PDF theme: Noto Sans as base, plus a fallback font for each
  /// script in [scripts]. May download a CJK font (call [needsDownload] first
  /// to tell the user). Throws [PdfFontDownloadException] if it can't.
  static Future<pw.ThemeData> themeFor(Set<PdfScript> scripts) async {
    final base = pw.Font.ttf(await rootBundle.load(_baseAsset));
    final fallback = <pw.Font>[];
    for (final s in scripts) {
      final asset = _bundled[s];
      if (asset != null) {
        fallback.add(pw.Font.ttf(await rootBundle.load(asset)));
        continue;
      }
      final name = _remote[s];
      if (name != null) {
        final bytes = await (await _ensureDownloaded(name)).readAsBytes();
        fallback.add(pw.Font.ttf(
            ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.length)));
      }
    }
    return pw.ThemeData.withFont(
      base: base,
      bold: base,
      italic: base,
      boldItalic: base,
      fontFallback: fallback,
    );
  }
}
