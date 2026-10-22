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

  /// Mean of the reader's own confidence over the words that contain letters
  /// of a non-Latin script, or null when there are none. Judging only those
  /// words keeps a clean English line beside them from lifting the score.
  /// Emulator runs: right readings 0.6-0.95 per word, wrong readers 0.05-0.29.
  static double? foreignConfidence(RecognizedText r) {
    var sum = 0.0, n = 0;
    for (final b in r.blocks) {
      for (final l in b.lines) {
        for (final e in l.elements) {
          final c = e.confidence;
          if (c != null && TextQuality.foreignLetters(e.text) > 0) {
            sum += c;
            n++;
          }
        }
      }
    }
    return n == 0 ? null : sum / n;
  }

  /// Non-Latin letters the reader read with confidence (words at or above
  /// [_minForeignConfidence]). The reader that reads most of them has read the
  /// photo best: on a Japanese menu the Chinese reader read one word at 0.77,
  /// the Japanese reader the whole menu at 0.65.
  static int foreignCoverage(RecognizedText r) {
    var n = 0;
    for (final b in r.blocks) {
      for (final l in b.lines) {
        for (final e in l.elements) {
          final c = e.confidence;
          if (c != null && c >= _minForeignConfidence) {
            n += TextQuality.foreignLetters(e.text);
          }
        }
      }
    }
    return n;
  }

  int _coverageOf(RecognizedText r) => _readingConfidence != null
      ? TextQuality.foreignLetters(r.text)
      : foreignCoverage(r);

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

  double? _foreignConfidenceOf(RecognizedText r) =>
      (_readingConfidence ?? foreignConfidence)(r);

  /// Reads [image]. With [script] set, only that reader runs (the user chose
  /// the source language).
  ///
  /// In Auto every reader reads the photo. The Latin reading is kept when it
  /// looks like real text and no other reader finds convincing text in its own
  /// script. A non-Latin reading counts when its non-Latin words are read with
  /// confidence and none of them mixes letters of two scripts (look-alike
  /// garbage such as Devanagari with Bengali letters inside one word); the one that
  /// reads the most of them confidently wins and also carries any Latin lines, which every reader
  /// reads the same. When nothing looks real the result is empty, so no
  /// gibberish is translated.
  Future<RecognizedText> recognize(InputImage image,
      {TextRecognitionScript? script}) async {
    if (script != null) return _run(script, image);

    final latin = await _run(TextRecognitionScript.latin, image);
    final latinText = latin.text.trim();
    final latinOk = latinText.isNotEmpty &&
        TextQuality.latinLooksReal(
            latinText, await _languageConfidence(latinText),
            readingConfidence: _confidenceOf(latin));

    final readings = await Future.wait(
        _others.map((s) async => (reading: await _run(s, image))));
    RecognizedText? best;
    var bestCoverage = -1, bestConfidence = -1.0;
    for (final x in readings) {
      final r = x.reading;
      final text = r.text.trim();
      if (text.isEmpty ||
          TextQuality.foreignLetters(text) == 0 ||
          TextQuality.mixesForeignScripts(text)) {
        continue;
      }
      final c = _foreignConfidenceOf(r);
      if (c != null && c < _minForeignConfidence) continue;
      final coverage = _coverageOf(r);
      final conf = c ?? _minForeignConfidence;
      if (coverage > bestCoverage ||
          (coverage == bestCoverage && conf > bestConfidence)) {
        best = r;
        bestCoverage = coverage;
        bestConfidence = conf;
      }
    }
    if (best != null) return best;
    return latinOk ? latin : RecognizedText(text: '', blocks: const []);
  }

  /// Halfway between the best wrong reading (0.29) and the worst right one
  /// (0.62) in the emulator runs.
  static const double _minForeignConfidence = 0.45;
  static const _others = <TextRecognitionScript>[
    TextRecognitionScript.japanese,
    TextRecognitionScript.chinese,
    TextRecognitionScript.korean,
    TextRecognitionScript.devanagiri,
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
