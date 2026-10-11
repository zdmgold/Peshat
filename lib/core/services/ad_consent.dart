import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google UMP consent handling. Ads are only initialised and requested once
/// the SDK says consent allows it (see [canRequestAds]).
///
/// A consent message (GDPR / US states) must be created in the AdMob console
/// for the app; without one, users in regions that require consent get no ads.
class AdConsent {
  AdConsent._();
  static final AdConsent instance = AdConsent._();

  final ValueNotifier<bool> canRequestAds = ValueNotifier<bool>(false);
  final ValueNotifier<bool> privacyOptionsRequired = ValueNotifier<bool>(false);
  bool _adsStarted = false;

  /// Run once at launch (not awaited): updates consent info, shows the form
  /// if one is required, then initialises Mobile Ads when allowed.
  Future<void> gatherAndInit() async {
    final done = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () {
          ConsentForm.loadAndShowConsentFormIfRequired((FormError? _) {
            if (!done.isCompleted) done.complete();
          });
        },
        (FormError _) {
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future;
    } catch (_) {}
    await _refresh();
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
    } catch (_) {}
  }
}
