import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Google's official test interstitial unit ID. Replace before release.
const String _kTestInterstitialUnitId =
    'ca-app-pub-3940256099942544/1033173712';

const int _kThreshold = 5;
const int _kSessionCap = 4;
const Duration _kMinInterval = Duration(seconds: 120);
const int _kLifetimeWarmUp = 5;

const String _kPrefLaunchedBefore = 'interstitial_launched_before';
const String _kPrefLifetimeTranslations = 'lifetime_translations_count';
const String _kPrefLastShownMs = 'last_interstitial_ms';

/// Singleton managing interstitial ad frequency.
///
/// Gates checked in this order on every back-press from Result:
///   1. Purchased?         → never fire
///   2. First session?     → never fire
///   3. Warm-up met?       → need >= 5 lifetime translations
///   4. Session cap?       → max 4 per session
///   5. Interval?          → min 120s since last
///   6. Counter >= 5?      → event counter from any of: scan/import/
///                            text (all bump on ScanDone), copy, share,
///                            export .txt, export .pdf
/// Only when all six pass does the ad show, and the counter resets.
class InterstitialService {
  InterstitialService._();
  static final InterstitialService instance = InterstitialService._();

  SharedPreferences? _prefs;
  bool _purchased = false;
  bool _firstSession = true;
  int _sessionShown = 0;
  int _eventCounter = 0;

  /// Called once from main() after prefs are available.
  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    final launchedBefore = prefs.getBool(_kPrefLaunchedBefore) ?? false;
    _firstSession = !launchedBefore;
    // Mark this launch as "before" for the next cold start, immediately.
    await prefs.setBool(_kPrefLaunchedBefore, true);
  }

  /// Called from main() whenever the purchase state changes.
  void setPurchased(bool value) => _purchased = value;

  /// Called by ResultScreen when the pipeline reaches ScanDone. Also bumps
  /// lifetime translations, which gates the warm-up period.
  Future<void> onTranslationCompleted() async {
    _eventCounter++;
    final p = _prefs;
    if (p != null) {
      final n = (p.getInt(_kPrefLifetimeTranslations) ?? 0) + 1;
      await p.setInt(_kPrefLifetimeTranslations, n);
    }
  }

  void onCopy() => _eventCounter++;
  void onShare() => _eventCounter++;
  void onExport() => _eventCounter++;

  /// Called from ResultScreen's PopScope when the user presses back.
  /// Returns true if an ad is about to be shown and the caller should
  /// delay the navigation until the ad is dismissed.
  Future<bool> maybeShowOnBack() async {
    if (!_passesGates()) return false;
    final p = _prefs;
    if (p == null) return false;

    final completer = Completer<bool>();
    InterstitialAd.load(
      adUnitId: _kTestInterstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (a) {
              a.dispose();
              if (!completer.isCompleted) completer.complete(true);
            },
            onAdFailedToShowFullScreenContent: (a, err) {
              a.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
          );
          _sessionShown++;
          _eventCounter = 0;
          p.setInt(_kPrefLastShownMs,
              DateTime.now().millisecondsSinceEpoch);
          ad.show();
        },
        onAdFailedToLoad: (err) {
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    // Hard timeout so a hung network never blocks navigation.
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => false,
    );
  }

  bool _passesGates() {
    if (_purchased) return false;
    if (_firstSession) return false;
    final p = _prefs;
    if (p == null) return false;
    final lifetime = p.getInt(_kPrefLifetimeTranslations) ?? 0;
    if (lifetime < _kLifetimeWarmUp) return false;
    if (_sessionShown >= _kSessionCap) return false;
    final lastMs = p.getInt(_kPrefLastShownMs) ?? 0;
    final since = DateTime.now().millisecondsSinceEpoch - lastMs;
    if (since < _kMinInterval.inMilliseconds) return false;
    if (_eventCounter < _kThreshold) return false;
    return true;
  }

  @visibleForTesting
  void resetForTest() {
    _sessionShown = 0;
    _eventCounter = 0;
    _firstSession = true;
    _purchased = false;
  }
}
