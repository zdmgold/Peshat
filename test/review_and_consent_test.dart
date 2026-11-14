import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/ad_consent.dart';
import 'package:peshat/core/services/interstitial_service.dart';
import 'package:peshat/core/services/review_prompt.dart';

void main() {
  const min = 60 * 1000;
  const now = 1000 * 60 * min;

  group('interstitial gap', () {
    test('needs at least 7 minutes since the last one', () {
      expect(interstitialGapPassed(now, now - 6 * min), isFalse);
      expect(interstitialGapPassed(now, now - 7 * min), isTrue);
      expect(interstitialGapPassed(now, now - 60 * min), isTrue);
    });
    test('first ever ad (nothing stored) is allowed by the gap', () {
      expect(interstitialGapPassed(now, 0), isTrue);
    });
  });

  group('consentOutcome', () {
    test('an error always allows ads', () {
      expect(consentOutcome(errored: true, sdkCanRequestAds: false), isTrue);
      expect(consentOutcome(errored: true, sdkCanRequestAds: true), isTrue);
    });
    test('without an error Google\'s answer is used', () {
      expect(consentOutcome(errored: false, sdkCanRequestAds: true), isTrue);
      expect(consentOutcome(errored: false, sdkCanRequestAds: false), isFalse);
    });
  });

  group('consent retry rule', () {
    test('retries after any failure', () {
      expect(shouldRetryConsent(infoFailed: true, refreshFailed: false), isTrue);
      expect(shouldRetryConsent(infoFailed: false, refreshFailed: true), isTrue);
    });
    test('does not retry when nothing failed', () {
      expect(
          shouldRetryConsent(infoFailed: false, refreshFailed: false), isFalse);
    });
  });

  group('review popup rules', () {
    bool eligible({
      int translations = 10,
      int days = 3,
      int lastAd = 0,
      bool busy = false,
      bool requested = false,
    }) =>
        reviewPopupEligible(
          translations: translations,
          distinctDays: days,
          nowMs: now,
          lastInterstitialMs: lastAd,
          consentBusy: busy,
          requestedThisLaunch: requested,
        );

    test('after 10 translations on 3 days', () {
      expect(eligible(), isTrue);
    });
    test('needs 10 translations', () {
      expect(eligible(translations: 9), isFalse);
    });
    test('needs 3 different days', () {
      expect(eligible(days: 2), isFalse);
    });
    test('at most once per launch', () {
      expect(eligible(requested: true), isFalse);
    });
    test('not within 10 minutes of an interstitial', () {
      expect(eligible(lastAd: now - 9 * min), isFalse);
      expect(eligible(lastAd: now - 10 * min), isTrue);
    });
    test('not while the consent form is running', () {
      expect(eligible(busy: true), isFalse);
    });
  });
}
