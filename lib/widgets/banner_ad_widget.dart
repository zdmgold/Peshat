import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google's official test banner unit ID. Replace before release.
const String _kBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

/// Fixed-height container that reserves space for an anchored adaptive
/// banner. The height is computed once per width from AdMob's own size
/// request, so the container never reflows between first frame and ad
/// load, and the ad never overflows the container horizontally.
///
/// The parent (AdSlot) owns padding, radius and shadow. This widget is
/// purely the ad surface and its reserved height.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isDisposed = false;
  int? _loadedForWidth;
  double _reservedHeight = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (_loadedForWidth != width) {
      _loadedForWidth = width;
      _reloadForWidth(width);
    }
  }

  Future<void> _reloadForWidth(int width) async {
    _bannerAd?.dispose();
    _bannerAd = null;
    if (mounted) setState(() => _isLoaded = false);

    final requested =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    final AdSize size = requested ?? AdSize.banner;
    if (!mounted || _isDisposed) return;

    setState(() => _reservedHeight = size.height.toDouble());

    final ad = BannerAd(
      adUnitId: _kBannerAdUnitId,
      size: size,
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
    return SizedBox(
      height: _reservedHeight,
      width: double.infinity,
      child: _isLoaded && _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : const SizedBox.shrink(),
    );
  }
}
