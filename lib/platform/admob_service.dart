import 'package:google_mobile_ads/google_mobile_ads.dart';

const String kBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

class AdMobService {
  BannerAd? _banner;

  Future<void> loadBanner({
    required void Function() onLoaded,
    required void Function() onFailed,
  }) async {
    try {
      _banner = BannerAd(
        adUnitId: kBannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => onLoaded(),
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
            onFailed();
          },
        ),
      )..load();
    } catch (_) {
      onFailed();
    }
  }

  void dispose() {
    _banner?.dispose();
  }
}
