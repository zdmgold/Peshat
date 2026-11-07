import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google UMP consent handling. Ads are only initialised and requested once
/// the SDK says consent allows it (see [canRequestAds]).
///
/// If a person declines, Google decides what (limited or non-personalised ads,
/// or none) is allowed; this class only follows its answer.
///
/// A consent message (GDPR / US states) must be created in the AdMob console
/// for the app; without one, users in regions that require consent get no ads.
/// Pure rule: a failed consent check is worth retrying when it failed and the
/// SDK still says ads can't be requested. Google's answer is never overridden.
@visibleForTesting
bool shouldRetryConsent({
  required bool infoFailed,
  required bool refreshFailed,
  required bool canRequestAds,
}) =>
    (infoFailed || refreshFailed) && !canRequestAds;

class AdConsent {
  AdConsent._();
  static final AdConsent instance = AdConsent._();

  final ValueNotifier<bool> canRequestAds = ValueNotifier<bool>(false);
  final ValueNotifier<bool> privacyOptionsRequired = ValueNotifier<bool>(false);
  bool _adsStarted = false;
  bool _infoFailed = false;
  bool _refreshFailed = false;

  /// True while the consent check / form is running.
  bool busy = false;

  /// Run once at launch (not awaited): updates consent info, shows the form
  /// if one is required, then initialises Mobile Ads when allowed.
  Future<void> gatherAndInit() async {
    if (busy) return;
    busy = true;
    _infoFailed = false;
    final done = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () {
          ConsentForm.loadAndShowConsentFormIfRequired((FormError? e) {
            if (e != null) _infoFailed = true;
            if (!done.isCompleted) done.complete();
          });
        },
        (FormError _) {
          _infoFailed = true;
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future;
    } catch (_) {
      _infoFailed = true;
    }
    await _refresh();
    busy = false;
  }

  /// Called when the app returns to the foreground: tries again only if the
  /// last check failed and ads still can't be requested.
  Future<void> retryIfNeeded() async {
    if (busy ||
        !shouldRetryConsent(
          infoFailed: _infoFailed,
          refreshFailed: _refreshFailed,
          canRequestAds: canRequestAds.value,
        )) {
      return;
    }
    await gatherAndInit();
  }

  /// Re-opens the consent choices form (required by the UMP rules where the
  /// SDK reports [privacyOptionsRequired]).
  Future<void> showPrivacyOptions() async {
    final done = Completer<void>();
    try {
      ConsentForm.showPrivacyOptionsForm((FormError? _) {
        if (!done.isCompleted) done.complete();
      });
      await done.future;
    } catch (_) {}
    await _refresh();
  }

  Future<void> _refresh() async {
    _refreshFailed = false;
    try {
      final can = await ConsentInformation.instance.canRequestAds();
      privacyOptionsRequired.value = await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
      if (can && !_adsStarted) {
        _adsStarted = true;
        await MobileAds.instance.initialize();
      }
      canRequestAds.value = can;
    } catch (e) {
      // Not silent: remember it so the next foreground retries.
      _refreshFailed = true;
      debugPrint('Ad consent refresh failed: $e');
    }
  }
}
