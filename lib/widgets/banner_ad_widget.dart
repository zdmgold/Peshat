import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google's official test banner unit ID. Replace before release.
const String _kBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

/// Fixed-standard-size bottom banner.
///
/// KatharScan / Atrament parity:
///   - [AdSize.banner] is always requested, never anchored adaptive.
///   - No horizontal padding inside the widget.
///   - No background, radius, or shadow. The page shows through.
///   - Collapses to zero height while loading or after any failure.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ad = BannerAd(
      adUnitId: _kBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loaded) {
          if (!mounted || _isDisposed) {
            loaded.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (failed, error) {
          failed.dispose();
          if (!mounted || _isDisposed) return;
          setState(() => _isLoaded = false);
        },
      ),
    );
    _bannerAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return Center(
      child: SizedBox(
        width: 320,
        height: 50,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
