import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/widgets/auto_direction_text.dart';

TextDirection _directionOf(WidgetTester tester, String text) {
  return tester.widget<Text>(find.text(text)).textDirection!;
}

void main() {
  testWidgets('follows the direction of its own content', (tester) async {
    const hebrew = 'עדיין אימות iOS: בדיקת אנדרואיד';
    const arabic = 'لا يزال التحقق من iOS';
    const english = 'Still verifying iOS';
    const digits = '5:48';

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            AutoDirectionText(hebrew),
            AutoDirectionText(arabic),
            AutoDirectionText(english),
            AutoDirectionText(digits),
          ],
        ),
      ),
    );

    expect(_directionOf(tester, hebrew), TextDirection.rtl);
    expect(_directionOf(tester, arabic), TextDirection.rtl);
    expect(_directionOf(tester, english), TextDirection.ltr);
    expect(_directionOf(tester, digits), TextDirection.ltr);
  });
}
