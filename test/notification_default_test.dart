import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reminders are on by default', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    expect(NotificationProvider(prefs).value, isTrue);
  });

  test('an explicit off stays off', () async {
    SharedPreferences.setMockInitialValues({'notif_reminder_enabled': false});
    final prefs = await SharedPreferences.getInstance();
    expect(NotificationProvider(prefs).value, isFalse);
  });
}
