import 'package:intl/intl.dart';

/// Whole calendar days from [t] to [now] (0 = same day, 1 = yesterday).
/// Compares dates, not 24-hour blocks, and is unaffected by DST changes.
int calendarDaysBetween(DateTime now, DateTime t) =>
    DateTime.utc(now.year, now.month, now.day)
        .difference(DateTime.utc(t.year, t.month, t.day))
        .inDays;

/// "14:32" for today; "11 Oct 2026 · 14:32" (localised) for any other day.
String historyTimeLabel(DateTime t, DateTime now, String localeName) {
  final hh = t.hour.toString().padLeft(2, '0');
  final mm = t.minute.toString().padLeft(2, '0');
  final time = '$hh:$mm';
  if (calendarDaysBetween(now, t) == 0) return time;
  String date;
  try {
    date = DateFormat.yMMMd(localeName).format(t);
  } catch (_) {
    final m = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    date = '${t.year}-$m-$d';
  }
  return '$date · $time';
}
