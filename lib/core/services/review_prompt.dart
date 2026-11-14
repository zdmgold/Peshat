import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_consent.dart';

const int _kMinTranslations = 10;
const int _kMinDays = 3;
const Duration _kAdQuietPeriod = Duration(minutes: 10);

const String _kPrefDays = 'review_days';
// Written by InterstitialService; read here only.
const String _kPrefLifetime = 'lifetime_translations_count';
const String _kPrefLastInterstitialMs = 'last_interstitial_ms';

/// Pure rule: may Google's in-app review popup be requested right now?
/// There are no cooldowns of our own (Google controls the quota).
@visibleForTesting
bool reviewPopupEligible({
  required int translations,
  required int distinctDays,
  required int nowMs,
  required int lastInterstitialMs,
  required bool consentBusy,
  required bool requestedThisLaunch,
}) {
  if (requestedThisLaunch || consentBusy) return false;
  if (translations < _kMinTranslations) return false;
  if (distinctDays < _kMinDays) return false;
  if (nowMs - lastInterstitialMs < _kAdQuietPeriod.inMilliseconds) {
    return false;
  }
  return true;
}

/// Asks Google's in-app review popup after the 10th translation across at
/// least 3 different days, at most once per app launch, never within 10
/// minutes of an interstitial or while the consent form is running.
class ReviewPrompt {
  ReviewPrompt._();
  static final ReviewPrompt instance = ReviewPrompt._();

  SharedPreferences? _prefs;
  bool _requestedThisLaunch = false;

  void init(SharedPreferences prefs) => _prefs = prefs;

  static String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Called when a translation completes: remembers the calendar day.
  void onTranslationCompleted() {
    final p = _prefs;
    if (p == null) return;
    final days = p.getStringList(_kPrefDays) ?? <String>[];
    final today = _dayKey(DateTime.now());
    if (days.contains(today) || days.length >= _kMinDays) return;
    p.setStringList(_kPrefDays, [...days, today]);
  }

  /// Re-evaluates; called when the home screen appears or is returned to.
  void refresh() {
    final p = _prefs;
    if (p == null) return;
    final ok = reviewPopupEligible(
      translations: p.getInt(_kPrefLifetime) ?? 0,
      distinctDays: (p.getStringList(_kPrefDays) ?? const <String>[]).length,
      nowMs: DateTime.now().millisecondsSinceEpoch,
      lastInterstitialMs: p.getInt(_kPrefLastInterstitialMs) ?? 0,
      consentBusy: AdConsent.instance.busy,
      requestedThisLaunch: _requestedThisLaunch,
    );
    if (!ok) return;
    _requestedThisLaunch = true;
    _request();
  }

  Future<void> _request() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) await review.requestReview();
    } catch (_) {
      // The OS may decline to show the prompt; that is not an error.
    }
  }
}
