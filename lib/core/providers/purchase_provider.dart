import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseProvider extends ValueNotifier<bool> {
  PurchaseProvider(SharedPreferences prefs)
      : super(prefs.getBool('ads_removed') ?? false);

  void markAdsRemoved(SharedPreferences prefs) {
    value = true;
    prefs.setBool('ads_removed', true);
  }
}
