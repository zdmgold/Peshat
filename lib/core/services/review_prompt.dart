import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_consent.dart';

const int _kMinTranslations = 10;
const int _kMinDays = 3;
const Duration _kAdQuietPeriod = Duration(minutes: 10);

/// Days to wait after the 1st, 2nd and 3rd dismissal. The 4th hides the card
/// for good.
const List<int> kReviewCooldownDays = [30, 30, 60];

const String _kPrefDays = 'review_days';
const String _kPrefDismissCount = 'review_dismiss_count';
const String _kPrefNextEligibleMs = 'review_next_eligible_ms';
const String _kPrefDone = 'review_done';
// Written by InterstitialService; read here only.
const String _kPrefLifetime = 'lifetime_translations_count';
const String _kPrefLastInterstitialMs = 'last_interstitial_ms';

/// Pure rule: should the rating card be shown right now?
@visibleForTesting
bool reviewCardEligible({
  required bool done,
  required int translations,
  required int distinctDays,
  required int nowMs,
  required int nextEligibleMs,
  required int lastInterstitialMs,
  required bool consentBusy,
  required bool shownThisLaunch,
}) {
  if (done || shownThisLaunch || consentBusy) return false;
  if (translations < _kMinTranslations) return false;
  if (distinctDays < _kMinDays) return false;
  if (nowMs < nextEligibleMs) return false;
  if (nowMs - lastInterstitialMs < _kAdQuietPeriod.inMilliseconds) {
    return false;
  }
  return true;
}

/// Next-eligible time after the [dismissCount]-th dismissal, or null when the
/// card must stay hidden for good (4th dismissal).
@visibleForTesting
int? reviewNextEligibleAfterDismiss(int dismissCount, int nowMs) {
  if (dismissCount > kReviewCooldownDays.length) return null;
  return nowMs +
      Duration(days: kReviewCooldownDays[dismissCount - 1]).inMilliseconds;
}

/// Home-screen rating card: shown after the 10th translation across at least
/// 3 different days, at most once per app launch, never within 10 minutes of
/// an interstitial or while the consent form is up.
class ReviewPrompt {
  ReviewPrompt._();
  static final ReviewPrompt instance = ReviewPrompt._();

  final ValueNotifier<bool> visible = ValueNotifier<bool>(false);
  SharedPreferences? _prefs;
  bool _shownThisLaunch = false;

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

  /// Re-evaluates; call when the home screen appears or is returned to.
  void refresh() {
    final p = _prefs;
    if (p == null || visible.value) return;
    final ok = reviewCardEligible(
      done: p.getBool(_kPrefDone) ?? false,
      translations: p.getInt(_kPrefLifetime) ?? 0,
      distinctDays: (p.getStringList(_kPrefDays) ?? const <String>[]).length,
      nowMs: DateTime.now().millisecondsSinceEpoch,
      nextEligibleMs: p.getInt(_kPrefNextEligibleMs) ?? 0,
      lastInterstitialMs: p.getInt(_kPrefLastInterstitialMs) ?? 0,
      consentBusy: AdConsent.instance.busy,
      shownThisLaunch: _shownThisLaunch,
    );
    if (ok) {
      _shownThisLaunch = true;
      visible.value = true;
    }
  }

  Future<void> dismiss() async {
    visible.value = false;
    final p = _prefs;
    if (p == null) return;
    final count = (p.getInt(_kPrefDismissCount) ?? 0) + 1;
    await p.setInt(_kPrefDismissCount, count);
    final next =
        reviewNextEligibleAfterDismiss(count, DateTime.now().millisecondsSinceEpoch);
    if (next == null) {
      await p.setBool(_kPrefDone, true);
    } else {
      await p.setInt(_kPrefNextEligibleMs, next);
    }
  }

  Future<void> rate() async {
    visible.value = false;
    await _prefs?.setBool(_kPrefDone, true);
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      } else {
        await review.openStoreListing();
      }
    } catch (_) {
      // The OS may decline to show the prompt; that is not an error.
    }
  }
}
