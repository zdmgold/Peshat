import 'language_detector.dart';
import 'mixed_text.dart';
import 'scan_scripts.dart';
import 'text_quality.dart';
import 'translator_service.dart';

/// One piece of a mixed text and the language it is translated from
/// (null: keep as written).
class MixedPiece {
  const MixedPiece(this.text, this.from);
  final String text;
  final String? from;
}

/// Translates only the runs that need it, each with the model for its own
/// language. See [MixedText].
class MixedTranslation {
  MixedTranslation(this._detector);

  final LanguageDetector _detector;

  /// A language for each script when detection cannot tell.
  static const Map<String, String> scriptDefault = <String, String>{
    'cyrillic': 'ru',
    'greek': 'el',
    'hebrew': 'he',
    'arabic': 'ar',
    'devanagari': 'hi',
    'bengali': 'bn',
    'gujarati': 'gu',
    'tamil': 'ta',
    'telugu': 'te',
    'kannada': 'kn',
    'thai': 'th',
    'georgian': 'ka',
    'cjk': 'zh',
    'hangul': 'ko',
  };

  /// Language of all the text in one foreign script. [preferred] is the
  /// source the user chose, used when it is a language of that script.
  Future<String?> _languageOf(
      String key, String joined, String? preferred) async {
    if (key == 'cjk' && TextQuality.hasKana(joined)) return 'ja';
    // Letters only: a full stop after a Cyrillic word flipped Russian to
    // Belarusian in emulator runs.
    joined = joined
        .replaceAll(RegExp(r'[^\p{L}\p{M}\s]', unicode: true), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    var found = 'und';
    try {
      found = await _detector.detect(joined).timeout(const Duration(seconds: 5));
    } catch (_) {}
    if (found != 'und' && !TranslatorService.isTranslatable(found)) {
      found = unsupportedStandIn[found] ?? 'und';
    }
    if (found != 'und' &&
        preferred != null &&
        confusableWith(found, preferred) &&
        _scriptOf(preferred) == key) {
      return preferred;
    }
    if (found != 'und' && _scriptOf(found) == key) return found;
    if (preferred != null && _scriptOf(preferred) == key) return preferred;
    return scriptDefault[key];
  }

  static String? _scriptOf(String code) {
    for (final e in scriptDefault.entries) {
      if (_languages[e.key]?.contains(code) ?? false) return e.key;
    }
    return null;
  }

  static const Map<String, Set<String>> _languages = <String, Set<String>>{
    'cyrillic': {'ru', 'uk', 'bg', 'be', 'mk'},
    'greek': {'el'},
    'hebrew': {'he'},
    'arabic': {'ar', 'fa', 'ur'},
    'devanagari': {'hi', 'mr'},
    'bengali': {'bn'},
    'gujarati': {'gu'},
    'tamil': {'ta'},
    'telugu': {'te'},
    'kannada': {'kn'},
    'thai': {'th'},
    'georgian': {'ka'},
    'cjk': {'zh', 'ja'},
    'hangul': {'ko'},
  };

  /// Longest English (Latin) stretch, in words, that still counts as words
  /// dropped into a foreign sentence ("office", "WiFi password reception").
  /// Emulator runs: foreign sentences with such words translated best whole
  /// (1-4 words, e.g. "Prime Minister Narendra Modi"); with a full English
  /// sentence inside (5-9 words) they translated best run by run.
  static const int embeddedLatinWords = 4;

  /// When [text] is a foreign sentence with a few Latin words inside (it starts
  /// and ends in the same foreign script, and every Latin stretch is short):
  /// the language to translate all of it from. Otherwise null.
  Future<String?> wholeTextLanguage(String text, String? preferredSource) async {
    final runs = MixedText.split(text);
    if (runs.length < 3) return null;
    final first = runs.first, last = runs.last;
    if (first.isLatin || first.key != last.key) return null;
    for (final r in runs) {
      if (r.isLatin &&
          r.text.trim().split(RegExp(r'\s+')).length > embeddedLatinWords) {
        return null;
      }
    }
    final joined = runs.where((r) => r.key == first.key).map((r) => r.text).join(' ');
    return _languageOf(first.key, joined, preferredSource);
  }

  /// The foreign language with the most text in [pieces], or 'en'.
  static String mainLanguage(List<MixedPiece> pieces) {
    final size = <String, int>{};
    for (final p in pieces) {
      if (p.from != null) size[p.from!] = (size[p.from!] ?? 0) + p.text.length;
    }
    if (size.isEmpty) return 'en';
    return size.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }

  /// Cuts [text] into pieces and says which model each goes to for [target].
  Future<List<MixedPiece>> plan(String text, String target,
      {String? preferredSource}) async {
    final runs = MixedText.split(text);
    final byScript = <String, StringBuffer>{};
    for (final r in runs) {
      if (r.isLatin) continue;
      (byScript[r.key] ??= StringBuffer()).write('${r.text} ');
    }
    final language = <String, String?>{};
    for (final e in byScript.entries) {
      language[e.key] =
          await _languageOf(e.key, e.value.toString().trim(), preferredSource);
    }
    final latin = runs.where((r) => r.isLatin).map((r) => r.text).join(' ');
    var latinLang = 'en';
    if (preferredSource != null &&
        _scriptOf(preferredSource) == null &&
        TranslatorService.isTranslatable(preferredSource)) {
      latinLang = preferredSource; // the user chose a Latin-script language
    } else if (latin.isNotEmpty && !TextQuality.isShortLatin(latin)) {
      try {
        final d = await _detector.detect(latin).timeout(const Duration(seconds: 5));
        if (d != 'und' && TranslatorService.isTranslatable(d)) latinLang = d;
      } catch (_) {}
    }
    return <MixedPiece>[
      for (final r in runs)
        MixedPiece(
            r.text,
            r.isLatin
                ? (isSameLanguage(latinLang, target) ? null : latinLang)
                : (language[r.key] != null &&
                        !isSameLanguage(language[r.key]!, target)
                    ? language[r.key]
                    : null)),
    ];
  }

  /// Languages whose models the plan uses, besides [target] and English.
  static Set<String> languagesIn(List<MixedPiece> pieces) =>
      <String>{for (final p in pieces) if (p.from != null) p.from!};

  /// Runs the plan: pieces to keep stay as written, the rest are translated
  /// with their own model. Spaces around each piece are kept.
  static Future<String> run(
    List<MixedPiece> pieces,
    String target,
    Future<String> Function(String text, String from, String to) translate,
  ) async {
    final out = StringBuffer();
    var last = '';
    void write(String t) {
      if (t.isEmpty) return;
      // Chinese and Japanese write no space after a full stop; the English
      // after it needs one.
      if (last.isNotEmpty &&
          !RegExp(r'\s').hasMatch(last) &&
          RegExp(r'^[\p{L}\p{N}]', unicode: true).hasMatch(t)) {
        out.write(' ');
      }
      out.write(t);
      last = t.substring(t.length - 1);
    }

    for (final p in pieces) {
      final from = p.from;
      final core = p.text.trim();
      if (from == null || core.isEmpty) {
        write(p.text);
        continue;
      }
      final lead = p.text.substring(0, p.text.indexOf(core));
      final trail = p.text.substring(lead.length + core.length);
      write(lead);
      write(await translate(core, from, target));
      write(trail);
    }
    return out.toString();
  }
}
