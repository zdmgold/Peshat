import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../../l10n/app_localizations.dart';

/// Local-notification reminder service.
///
/// Schedules a single "come back to Peshat" reminder 3 days out, using the
/// user's current UI locale for the notification text. The reminder is
/// cancelled and rescheduled on every cold start so an active user never
/// receives one. No-op unless the user has enabled reminders in Settings.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _keyEnabled = 'notif_reminder_enabled';
  static const _keyLocale = 'ui_locale';
  static const _channelId = 'peshat_reminder';
  static const _channelName = 'Reminders';
  static const _channelDescription = 'Reminders to continue using Peshat.';
  static const _notificationId = 1;
  static const _delayDays = 3;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init(SharedPreferences prefs) async {
    if (_initialized) return;
    _initialized = true;

    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final enabled = prefs.getBool(_keyEnabled) ?? false;
    if (enabled) {
      await _cancelReminder();
      await _scheduleReminder(prefs);
    }
  }

  Future<bool> requestPermission() async {
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  Future<void> setEnabled(SharedPreferences prefs, bool enabled) async {
    await prefs.setBool(_keyEnabled, enabled);
    if (enabled) {
      await _cancelReminder();
      await _scheduleReminder(prefs);
    } else {
      await _cancelReminder();
    }
  }

  Locale _resolveLocale(SharedPreferences prefs) {
    final saved = prefs.getString(_keyLocale);
    if (saved != null && saved.isNotEmpty && saved != 'system') {
      return Locale(saved);
    }
    return PlatformDispatcher.instance.locale;
  }

  Future<void> _scheduleReminder(SharedPreferences prefs) async {
    final l10n = await AppLocalizations.delegate.load(_resolveLocale(prefs));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final fireAt = tz.TZDateTime.now(tz.local).add(const Duration(days: _delayDays));

    await _plugin.zonedSchedule(
      _notificationId,
      l10n.reminderNotificationTitle,
      l10n.reminderNotificationBody,
      fireAt,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> _cancelReminder() async {
    await _plugin.cancel(_notificationId);
  }
}
