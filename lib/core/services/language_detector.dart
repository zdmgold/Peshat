import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class LanguageDetector {
  final _identifier = LanguageIdentifier(confidenceThreshold: 0.5);

  Future<String> detect(String text) async {
    // identifyLanguage returns a non-nullable String. 
    // It returns 'und' if the language cannot be determined.
    final String language = await _identifier.identifyLanguage(text);
    return language == 'und' ? 'en' : language;
  }

  void dispose() {
    _identifier.close();
  }
}
