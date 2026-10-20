import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'text_quality.dart';

class TextRecognizerService {
  /// [reader] and [confidence] exist so tests can supply canned readings.
  TextRecognizerService({
    Future<RecognizedText> Function(TextRecognitionScript, InputImage)? reader,
    Future<double> Function(String)? confidence,
  })  : _reader = reader,
        _confidence = confidence;

  final Future<RecognizedText> Function(TextRecognitionScript, InputImage)?
      _reader;
  final Future<double> Function(String)? _confidence;
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

  /// Reads [image]. With [script] set, only that reader runs (the user chose
  /// the source language).
  ///
  /// In Auto the Latin reader runs first. Its answer is kept only when it looks
  /// like real text; otherwise the other readers get a turn and the first one
  /// that returns its own script wins. When nothing looks real the result is
  /// empty, so no gibberish is translated.
  Future<RecognizedText> recognize(InputImage image,
      {TextRecognitionScript? script}) async {
    if (script != null) return _run(script, image);

    final latin = await _run(TextRecognitionScript.latin, image);
    final latinText = latin.text.trim();
    if (latinText.isNotEmpty &&
        TextQuality.latinLooksReal(
            latinText, await _languageConfidence(latinText))) {
      return latin;
    }

    final japanese = await _run(TextRecognitionScript.japanese, image);
    final jaText = japanese.text.trim();
    if (jaText.isNotEmpty &&
        TextQuality.hasKana(jaText) &&
        TextQuality.scriptLooksReal(jaText, ScriptGroup.cjk)) {
      return japanese;
    }
    final chinese = await _run(TextRecognitionScript.chinese, image);
    if (chinese.text.trim().isNotEmpty &&
        TextQuality.scriptLooksReal(chinese.text.trim(), ScriptGroup.cjk)) {
      return chinese;
    }
    final korean = await _run(TextRecognitionScript.korean, image);
    if (korean.text.trim().isNotEmpty &&
        TextQuality.scriptLooksReal(korean.text.trim(), ScriptGroup.hangul)) {
      return korean;
    }
    final hindi = await _run(TextRecognitionScript.devanagiri, image);
    if (hindi.text.trim().isNotEmpty &&
        TextQuality.scriptLooksReal(
            hindi.text.trim(), ScriptGroup.devanagari)) {
      return hindi;
    }
    return RecognizedText(text: '', blocks: const []);
  }

  void dispose() {
    for (final r in _recognizers.values) {
      r.close();
    }
    _recognizers.clear();
    _identifier?.close();
    _identifier = null;
  }
}
