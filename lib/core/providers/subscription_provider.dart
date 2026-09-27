import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionProvider extends ValueNotifier<bool> {
  SubscriptionProvider(SharedPreferences prefs) : super(prefs.getBool('is_pro') ?? false);

  void markPro(SharedPreferences prefs) {
    value = true;
    prefs.setBool('is_pro', true);
  }
}
