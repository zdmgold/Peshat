import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Pure rule: an error always allows ads (the SDK then uses the last saved
/// choice and Google decides what to serve); otherwise Google's answer is used.
@visibleForTesting
bool consentOutcome({required bool errored, required bool sdkCanRequestAds}) =>
    errored || sdkCanRequestAds;

/// Pure rule: a failed consent check is worth retrying on the next foreground
/// so a form that could not be shown still gets another chance.
@visibleForTesting
bool shouldRetryConsent({
  required bool infoFailed,
  required bool refreshFailed,
}) =>
    infoFailed || refreshFailed;

/// Google UMP consent handling. Ads are initialised and requested once the
/// SDK says consent allows it, or when the consent check itself errors (then
/// the SDK uses the last saved choice; see [consentOutcome]).
///
/// If a person declines, Google decides what (limited or non-personalised ads,
/// or none) is allowed; this class only follows its answer.
///
/// A consent message (GDPR / US states) must be created in the AdMob console
/// for the app; without one, users in regions that require consent get no ads.
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
    var sdkCan = false;
    try {
      sdkCan = await ConsentInformation.instance.canRequestAds();
      privacyOptionsRequired.value = await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (e) {
      // Not silent: remember it so the next foreground retries.
      _refreshFailed = true;
      debugPrint('Ad consent refresh failed: $e');
    }
    final can = consentOutcome(
      errored: _infoFailed || _refreshFailed,
      sdkCanRequestAds: sdkCan,
    );
    try {
      if (can && !_adsStarted) {
        _adsStarted = true;
        await MobileAds.instance.initialize();
      }
    } catch (e) {
      _adsStarted = false;
      debugPrint('Mobile Ads init failed: $e');
    }
    canRequestAds.value = can;
  }
}
