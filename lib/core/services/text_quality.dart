import 'mixed_text.dart';

/// Judges whether text read from a photo looks real.
///
/// The Latin reader never returns nothing: given a photo of Cyrillic, Tamil or
/// Arabic it answers with look-alike gibberish ("Aoópoe yTpo, Kak y TeóA gena?").
/// These checks are calibrated on emulator runs (see test/text_quality_test.dart).
enum ScriptGroup { latin, cjk, hangul, devanagari, other }

class TextQuality {
  static final RegExp _letter = RegExp(r'[\p{L}\p{M}]', unicode: true);
  static final RegExp _edge =
      RegExp(r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$', unicode: true);
  static final RegExp _digit = RegExp(r'[0-9]');
  // Product-style tokens that legitimately mix letters and digits: 4K, A4, mp3,
  // 2kg, B2b, COVID19.
  static final RegExp _code = RegExp(
      r'^(\d+[A-Za-z]{1,2}|[A-Za-z]{1,2}\d+[A-Za-z]?|[A-Z]{2,}\d+)$');
  static final RegExp _lowerUpper = RegExp('[a-zà-ÿ][A-Z]');
  // iPhone, YouTube, McDonald.
  static final RegExp _camel =
      RegExp(r'^([A-Z][a-z]+){2,}$|^[a-z][A-Z][a-z]+$|^M[ac][A-Z][a-z]+$');

  static ScriptGroup scriptOf(int r) {
    if ((r >= 0x41 && r <= 0x5A) ||
        (r >= 0x61 && r <= 0x7A) ||
        (r >= 0xC0 && r <= 0x24F && r != 0xD7 && r != 0xF7) ||
        (r >= 0x1E00 && r <= 0x1EFF)) {
      return ScriptGroup.latin;
    }
    if ((r >= 0x4E00 && r <= 0x9FFF) ||
        (r >= 0x3400 && r <= 0x4DBF) ||
        (r >= 0x3040 && r <= 0x30FF)) {
      return ScriptGroup.cjk;
    }
    if ((r >= 0xAC00 && r <= 0xD7AF) ||
        (r >= 0x1100 && r <= 0x11FF) ||
        (r >= 0x3130 && r <= 0x318F)) {
      return ScriptGroup.hangul;
    }
    // Devanagari and Bengali: the Devanagari reader reads both.
    if (r >= 0x0900 && r <= 0x09FF) return ScriptGroup.devanagari;
    return ScriptGroup.other;
  }

  static Map<ScriptGroup, int> letterCounts(String text) {
    final counts = <ScriptGroup, int>{};
    for (final rune in text.runes) {
      if (!_letter.hasMatch(String.fromCharCode(rune))) continue;
      final g = scriptOf(rune);
      counts[g] = (counts[g] ?? 0) + 1;
    }
    return counts;
  }

  /// Share (0-1) of the letters in [text] that belong to [group].
  static double share(String text, ScriptGroup group) {
    final counts = letterCounts(text);
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return 0;
    return (counts[group] ?? 0) / total;
  }

  /// Letters in [text] that are not Latin (Devanagari, Han, Hangul, Arabic...).
  static int foreignLetters(String text) {
    final counts = letterCounts(text);
    var n = 0;
    counts.forEach((g, c) {
      if (g != ScriptGroup.latin) n += c;
    });
    return n;
  }

  /// Mixed text (an English word or caption beside another script): just the
  /// words that are not mostly Latin, so language detection judges the foreign
  /// part instead of being pulled to English or a stray language. Null when the
  /// text is not mixed or the foreign part is too short to judge.
  static String? foreignCore(String text) {
    final counts = letterCounts(text);
    if ((counts[ScriptGroup.latin] ?? 0) == 0 || foreignLetters(text) < 4) {
      return null;
    }
    final words = text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && share(w, ScriptGroup.latin) < 0.5)
        .toList();
    final core = words.join(' ');
    return foreignLetters(core) < 4 ? null : core;
  }

  /// Under 25 letters, nearly all Latin: too little for language detection.
  static bool isShortLatin(String text) {
    final counts = letterCounts(text);
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    return total > 0 && total < 25 && share(text, ScriptGroup.latin) >= 0.85;
  }

  static bool hasKana(String text) =>
      text.runes.any((r) => r >= 0x3040 && r <= 0x30FF);

  static bool _oddToken(String tok) {
    final letters = tok.runes
        .where((r) => _letter.hasMatch(String.fromCharCode(r)))
        .length;
    final hasDigit = _digit.hasMatch(tok);
    if (letters < 2 && !hasDigit) return false;
    if (hasDigit && letters > 0 && !_code.hasMatch(tok)) return true;
    if (_lowerUpper.hasMatch(tok) && !_camel.hasMatch(tok)) return true;
    return false;
  }

  /// Share (0-1) of words that mix digits or capitals in ways real words don't.
  static double oddTokenShare(String text) {
    final toks = text
        .split(RegExp(r'\s+'))
        .map((t) => t.replaceAll(_edge, ''))
        .where((t) => t.isNotEmpty)
        .toList();
    if (toks.isEmpty) return 0;
    return toks.where(_oddToken).length / toks.length;
  }

  /// True when [text], returned by the Latin reader, looks like real
  /// Latin-script text. [languageConfidence] is the top language-identification
  /// confidence (0-1) for [text].
  static bool latinLooksReal(String text, double languageConfidence,
      {double? readingConfidence}) {
    // The reader's own confidence: real Latin text scored 0.80-0.91 in
    // emulator runs; look-alike readings of other scripts scored 0.16-0.61.
    final counts = letterCounts(text);
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return _digit.hasMatch(text);
    if ((counts[ScriptGroup.latin] ?? 0) / total < 0.85) return false;
    // A confident reader is trusted: URLs, codes and languages that language
    // identification doesn't know (Filipino, Welsh) all scored 0.80+.
    if (readingConfidence != null) {
      if (readingConfidence >= 0.7) return true;
      if (readingConfidence < 0.65) return false;
    }
    final odd = oddTokenShare(text);
    if (odd >= 0.5) return false;
    if (text.length >= 12) {
      if (languageConfidence < 0.45) return false;
      if (languageConfidence < 0.6 && odd >= 0.34) return false;
    }
    return true;
  }

  /// True when a word mixes letters of two different non-Latin scripts
  /// (Devanagari with Bengali inside one word). Real words never do; a reader
  /// forced onto a script it cannot read produces them.
  static bool mixesForeignScripts(String text) {
    for (final word in text.split(RegExp(r'\s+'))) {
      String? first;
      for (final r in word.runes) {
        final k = MixedText.keyOf(r);
        if (k == null || k == MixedText.latinKey) continue;
        if (first == null) {
          first = k;
        } else if (k != first) {
          return true;
        }
      }
    }
    return false;
  }
}
