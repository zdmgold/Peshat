import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:peshat/core/services/translator_service.dart';

void main() {
  test('Filipino maps to the ML Kit model code, not the app code', () {
    expect(TranslatorService.languageFor('fil'), TranslateLanguage.tagalog);
    expect(TranslateLanguage.tagalog.bcpCode, 'tl');
  });

  test('every translatable language has a model code', () {
    for (final c in TranslatorService.translatableCodes) {
      expect(TranslatorService.languageFor(c)!.bcpCode, isNotEmpty);
    }
  });
}
