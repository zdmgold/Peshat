import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class LanguageDetector {
  final _identifier = LanguageIdentifier(confidenceThreshold: 0.5);

  /// The language code, or 'und' when it can't be told (callers decide what
  /// to assume: Filipino and Welsh sentences came back 'und' on the emulator).
  Future<String> detect(String text) => _identifier.identifyLanguage(text);

  void dispose() {
    _identifier.close();
  }
}
