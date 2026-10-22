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
    if (latin.isNotEmpty && !TextQuality.isShortLatin(latin)) {
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
    for (final p in pieces) {
      final from = p.from;
      final core = p.text.trim();
      if (from == null || core.isEmpty) {
        out.write(p.text);
        continue;
      }
      final lead = p.text.substring(0, p.text.indexOf(core));
      final trail = p.text.substring(lead.length + core.length);
      out
        ..write(lead)
        ..write(await translate(core, from, target))
        ..write(trail);
    }
    return out.toString();
  }
}
