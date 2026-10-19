import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/language_names.dart';

void main() {
  test('native name first, English after it', () {
    expect(languageLabel('de'), 'Deutsch · German');
    expect(languageLabel('zh'), '中文 · Chinese (Simplified)');
  });

  test('English shows once', () {
    expect(languageLabel('en'), 'English');
  });

  test('unknown code falls back to upper-case code', () {
    expect(languageLabel('xx'), 'XX');
  });

  test('English subtitle only when it differs from the native name', () {
    expect(languageEnglishSubtitle('sq'), 'Albanian');
    expect(languageEnglishSubtitle('te'), 'Telugu');
    expect(languageEnglishSubtitle('en'), isNull);
  });
}
