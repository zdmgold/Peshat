import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:peshat/core/utils/date_labels.dart';

void main() {
  setUpAll(() async => initializeDateFormatting());

  test('23:00 last night is yesterday, not today', () {
    final now = DateTime(2026, 10, 11, 10, 0);
    expect(calendarDaysBetween(now, DateTime(2026, 10, 10, 23, 0)), 1);
    expect(calendarDaysBetween(now, DateTime(2026, 10, 11, 0, 5)), 0);
    expect(calendarDaysBetween(now, DateTime(2026, 10, 9, 12, 0)), 2);
  });

  test('today shows only the time, other days show a date too', () {
    final now = DateTime(2026, 10, 11, 10, 0);
    expect(historyTimeLabel(DateTime(2026, 10, 11, 9, 5), now, 'en'), '09:05');
    final old = historyTimeLabel(DateTime(2026, 9, 3, 14, 32), now, 'en');
    expect(old, contains('2026'));
    expect(old, endsWith('· 14:32'));
  });
}
