import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

/// Boolean toggle for reminder notifications. Mirrors the shape of
/// PurchaseProvider: SharedPreferences-backed, exposed as ValueNotifier,
/// wired to the notification service on change.
class NotificationProvider extends ValueNotifier<bool> {
  final SharedPreferences prefs;

  NotificationProvider(this.prefs)
      : super(prefs.getBool('notif_reminder_enabled') ?? false);

  /// Request permission and enable. Returns true if the OS granted
  /// permission and the reminder was scheduled.
  Future<bool> enable() async {
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      value = false;
      await NotificationService.instance.setEnabled(prefs, false);
      return false;
    }
    value = true;
    await NotificationService.instance.setEnabled(prefs, true);
    return true;
  }

  Future<void> disable() async {
    value = false;
    await NotificationService.instance.setEnabled(prefs, false);
  }
}
