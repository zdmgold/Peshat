import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'text_quality.dart';

class TextRecognizerService {
  /// [reader] and [confidence] exist so tests can supply canned readings.
  TextRecognizerService({
    Future<RecognizedText> Function(TextRecognitionScript, InputImage)? reader,
    Future<double> Function(String)? confidence,
    double? Function(RecognizedText)? readingConfidence,
  })  : _reader = reader,
        _confidence = confidence,
        _readingConfidence = readingConfidence;

  final Future<RecognizedText> Function(TextRecognitionScript, InputImage)?
      _reader;
  final Future<double> Function(String)? _confidence;
  final double? Function(RecognizedText)? _readingConfidence;
  final _recognizers = <TextRecognitionScript, TextRecognizer>{};
  LanguageIdentifier? _identifier;

  Future<RecognizedText> _run(TextRecognitionScript script, InputImage image) {
    final custom = _reader;
    if (custom != null) return custom(script, image);
    final recognizer =
        _recognizers.putIfAbsent(script, () => TextRecognizer(script: script));
    return recognizer.processImage(image);
  }

  Future<double> _languageConfidence(String text) async {
    final custom = _confidence;
    if (custom != null) return custom(text);
    try {
      _identifier ??= LanguageIdentifier(confidenceThreshold: 0.01);
      final found = await _identifier!
          .identifyPossibleLanguages(text)
          .timeout(const Duration(seconds: 5));
      var best = 0.0;
      for (final l in found) {
        if (l.confidence > best) best = l.confidence;
      }
      return best;
    } catch (_) {
      // If language identification is unavailable, trust the Latin reader.
      return 1.0;
    }
  }

  /// Mean of the reader's own per-line confidence, or null when it has none.
  static double? readingConfidence(RecognizedText r) {
    var sum = 0.0, n = 0;
    for (final b in r.blocks) {
      for (final l in b.lines) {
        final c = l.confidence;
        if (c != null) {
          sum += c;
          n++;
        }
      }
    }
    return n == 0 ? null : sum / n;
  }

  double? _confidenceOf(RecognizedText r) =>
      (_readingConfidence ?? readingConfidence)(r);

  /// Reads [image]. With [script] set, only that reader runs (the user chose
  /// the source language).
  ///
  /// In Auto the Latin reader runs first and its answer is kept when it looks
  /// like real text. Otherwise every other reader reads the photo, readings
  /// that are not their own script or are low-confidence are dropped, and the
  /// most confident remaining one wins. When nothing looks real the result is
  /// empty, so no gibberish is translated. (Emulator runs: the right reader
  /// scored 0.60-0.91, wrong readers 0.14-0.32.)
  Future<RecognizedText> recognize(InputImage image,
      {TextRecognitionScript? script}) async {
    if (script != null) return _run(script, image);

    final latin = await _run(TextRecognitionScript.latin, image);
    final latinText = latin.text.trim();
    if (latinText.isNotEmpty &&
        TextQuality.latinLooksReal(
            latinText, await _languageConfidence(latinText),
            readingConfidence: _confidenceOf(latin))) {
      return latin;
    }

    RecognizedText? best;
    var bestConfidence = -1.0;
    for (final s in _others) {
      final r = await _run(s.script, image);
      final text = r.text.trim();
      if (text.isEmpty || !TextQuality.scriptLooksReal(text, s.group)) continue;
      final c = _confidenceOf(r);
      if (c != null && c < _minOtherConfidence) continue;
      if ((c ?? _minOtherConfidence) > bestConfidence) {
        best = r;
        bestConfidence = c ?? _minOtherConfidence;
      }
    }
    return best ?? RecognizedText(text: '', blocks: const []);
  }

  static const double _minOtherConfidence = 0.5;
  static const _others = <({TextRecognitionScript script, ScriptGroup group})>[
    (script: TextRecognitionScript.japanese, group: ScriptGroup.cjk),
    (script: TextRecognitionScript.chinese, group: ScriptGroup.cjk),
    (script: TextRecognitionScript.korean, group: ScriptGroup.hangul),
    (script: TextRecognitionScript.devanagiri, group: ScriptGroup.devanagari),
  ];

  void dispose() {
    for (final r in _recognizers.values) {
      r.close();
    }
    _recognizers.clear();
    _identifier?.close();
    _identifier = null;
  }
}
