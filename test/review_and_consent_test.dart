import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/ad_consent.dart';
import 'package:peshat/core/services/review_prompt.dart';

void main() {
  const day = 24 * 60 * 60 * 1000;
  const now = 100 * day;

  bool eligible({
    bool done = false,
    int translations = 10,
    int days = 3,
    int next = 0,
    int lastAd = 0,
    bool busy = false,
    bool shown = false,
  }) =>
      reviewCardEligible(
        done: done,
        translations: translations,
        distinctDays: days,
        nowMs: now,
        nextEligibleMs: next,
        lastInterstitialMs: lastAd,
        consentBusy: busy,
        shownThisLaunch: shown,
      );

  group('review card rules', () {
    test('shows after 10 translations on 3 days', () {
      expect(eligible(), isTrue);
    });
    test('needs 10 translations', () {
      expect(eligible(translations: 9), isFalse);
    });
    test('needs 3 different days', () {
      expect(eligible(days: 2), isFalse);
    });
    test('once per launch', () {
      expect(eligible(shown: true), isFalse);
    });
    test('never once done (rated or 4th dismiss)', () {
      expect(eligible(done: true), isFalse);
    });
    test('respects the cooldown', () {
      expect(eligible(next: now + 1), isFalse);
      expect(eligible(next: now), isTrue);
    });
    test('not within 10 minutes of an interstitial', () {
      expect(eligible(lastAd: now - 9 * 60 * 1000), isFalse);
      expect(eligible(lastAd: now - 10 * 60 * 1000), isTrue);
    });
    test('not while the consent form is up', () {
      expect(eligible(busy: true), isFalse);
    });
    test('dismiss cooldowns are 30, 30, 60 days, 4th hides for good', () {
      expect(reviewNextEligibleAfterDismiss(1, now), now + 30 * day);
      expect(reviewNextEligibleAfterDismiss(2, now), now + 30 * day);
      expect(reviewNextEligibleAfterDismiss(3, now), now + 60 * day);
      expect(reviewNextEligibleAfterDismiss(4, now), isNull);
    });
  });

  group('consent retry rule', () {
    test('retries a failed check while ads cannot be requested', () {
      expect(
          shouldRetryConsent(
              infoFailed: true, refreshFailed: false, canRequestAds: false),
          isTrue);
      expect(
          shouldRetryConsent(
              infoFailed: false, refreshFailed: true, canRequestAds: false),
          isTrue);
    });
    test('never retries when Google already allows ads or nothing failed', () {
      expect(
          shouldRetryConsent(
              infoFailed: true, refreshFailed: true, canRequestAds: true),
          isFalse);
      expect(
          shouldRetryConsent(
              infoFailed: false, refreshFailed: false, canRequestAds: false),
          isFalse);
    });
  });
}
