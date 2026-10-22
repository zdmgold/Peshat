import 'text_quality.dart';

/// Text that mixes scripts: a sign in English with a Hindi line under it, a menu
/// with Japanese names, a sentence with a Chinese phrase in the middle.
///
/// Translating it all with one language model garbles the other part (the
/// Hindi model turned "Welcome to the City Library" into "Welcome to Welcome to
/// the City Library Library"), so it is cut into runs, one per script, and each
/// run goes to the model for its own language.
class TextRun {
  const TextRun(this.text, this.key);

  /// The run as written, including the spaces, digits and punctuation after it.
  final String text;

  /// Script of the run: [latinKey] or one of the foreign script keys.
  final String key;

  bool get isLatin => key == MixedText.latinKey;

  @override
  String toString() => '$key:"$text"';
}

class MixedText {
  static const String latinKey = 'latin';

  /// Script of a letter: [latinKey], a foreign script name, or null when the
  /// character is not a letter (digits, spaces, punctuation, accents on their
  /// own), which stays with the run before it.
  static String? keyOf(int r) {
    final g = TextQuality.scriptOf(r);
    if (g == ScriptGroup.latin) return latinKey;
    if (!_isLetter(r)) return null;
    if (r >= 0x400 && r <= 0x52F) return 'cyrillic';
    if (r >= 0x370 && r <= 0x3FF) return 'greek';
    if (r >= 0x590 && r <= 0x5FF) return 'hebrew';
    if ((r >= 0x600 && r <= 0x6FF) ||
        (r >= 0x750 && r <= 0x77F) ||
        (r >= 0xFB50 && r <= 0xFDFF) ||
        (r >= 0xFE70 && r <= 0xFEFF)) {
      return 'arabic';
    }
    if (r >= 0x900 && r <= 0x97F) return 'devanagari';
    if (r >= 0x980 && r <= 0x9FF) return 'bengali';
    if (r >= 0xA80 && r <= 0xAFF) return 'gujarati';
    if (r >= 0xB80 && r <= 0xBFF) return 'tamil';
    if (r >= 0xC00 && r <= 0xC7F) return 'telugu';
    if (r >= 0xC80 && r <= 0xCFF) return 'kannada';
    if (r >= 0xE00 && r <= 0xE7F) return 'thai';
    if (r >= 0x10A0 && r <= 0x10FF) return 'georgian';
    if (g == ScriptGroup.cjk) return 'cjk';
    if (g == ScriptGroup.hangul) return 'hangul';
    return 'other';
  }

  static final RegExp _letterOrMark = RegExp(r'[\p{L}\p{M}]', unicode: true);
  static bool _isLetter(int r) =>
      _letterOrMark.hasMatch(String.fromCharCode(r));

  /// Cuts [text] into runs of one script each. Spaces, digits and punctuation
  /// stay with the run before them (the first run takes any that come first).
  static List<TextRun> split(String text) {
    final runs = <TextRun>[];
    final buf = StringBuffer();
    String? current;
    for (final r in text.runes) {
      final k = keyOf(r);
      if (k != null && k != current) {
        if (current != null) runs.add(TextRun(buf.toString(), current));
        buf.clear();
        current = k;
      }
      buf.writeCharCode(r);
    }
    if (current != null) runs.add(TextRun(buf.toString(), current));
    return runs;
  }

  /// Share (0-1) of the letters that are not Latin.
  static double foreignShare(String text) {
    var latin = 0, foreign = 0;
    for (final r in text.runes) {
      final k = keyOf(r);
      if (k == null) continue;
      if (k == latinKey) {
        latin++;
      } else {
        foreign++;
      }
    }
    final total = latin + foreign;
    return total == 0 ? 0 : foreign / total;
  }

  /// True when the text has both Latin letters and letters of another script.
  static bool isMixed(String text) {
    var latin = false, foreign = false;
    for (final r in text.runes) {
      final k = keyOf(r);
      if (k == null) continue;
      if (k == latinKey) {
        latin = true;
      } else {
        foreign = true;
      }
      if (latin && foreign) return true;
    }
    return false;
  }
}
