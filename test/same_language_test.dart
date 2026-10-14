import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/providers/scan_provider.dart';

void main() {
  test('same base language is detected regardless of region or case', () {
    expect(isSameLanguage('en', 'en'), isTrue);
    expect(isSameLanguage('EN', 'en-US'), isTrue);
    expect(isSameLanguage('zh', 'zh_CN'), isTrue);
    expect(isSameLanguage('en', 'de'), isFalse);
    expect(isSameLanguage('no', 'nn'), isFalse);
  });
}
