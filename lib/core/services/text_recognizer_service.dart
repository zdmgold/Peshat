import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognizerService {
  // Latin is tried first; the other scripts are created lazily and only when
  // the previous one found nothing, so Latin-only users pay no extra cost.
  static const _scripts = <TextRecognitionScript>[
    TextRecognitionScript.latin,
    TextRecognitionScript.chinese,
    TextRecognitionScript.japanese,
    TextRecognitionScript.korean,
    TextRecognitionScript.devanagiri,
  ];

  final _recognizers = <TextRecognitionScript, TextRecognizer>{};

  /// Reads [image]. With [script] set, only that reader runs (the user chose
  /// the source language); otherwise the readers are tried in order.
  Future<RecognizedText> recognize(InputImage image,
      {TextRecognitionScript? script}) async {
    if (script != null) {
      final recognizer = _recognizers.putIfAbsent(
          script, () => TextRecognizer(script: script));
      return recognizer.processImage(image);
    }
    RecognizedText? last;
    for (final script in _scripts) {
      final recognizer = _recognizers.putIfAbsent(
          script, () => TextRecognizer(script: script));
      final result = await recognizer.processImage(image);
      if (result.text.trim().isNotEmpty) return result;
      last = result;
    }
    return last!;
  }

  void dispose() {
    for (final r in _recognizers.values) {
      r.close();
    }
    _recognizers.clear();
  }
}
