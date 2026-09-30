import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/utils/app_colors.dart';

/// Google's official test banner unit ID. Replace before release.
const String _kBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

const double _kSideInset = 8;
const double _kPaddingAbove = 8;
const double _kPaddingBelow = 4;
const double _kTopRadius = 12;
const double _kShadowBlur = 8;
const double _kShadowYOffset = 2;
const double _kShadowAlpha = 0.5;

/// Bottom ad surface, including its padding, radius and shadow.
///
/// Renders nothing at all while the ad is loading or after it has failed.
/// Once loaded, draws the full chrome and the ad, matched to the width the
/// ad was sized against. This prevents the "empty shadowed box" that a
/// reserved-height placeholder produces on first mount.
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
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cream = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: _kPaddingAbove),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kSideInset),
          child: Container(
            decoration: BoxDecoration(
              color: cream,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_kTopRadius),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, _kShadowAlpha),
                  blurRadius: _kShadowBlur,
                  offset: Offset(0, -_kShadowYOffset),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_kTopRadius),
              ),
              child: SizedBox(
                height: _reservedHeight,
                width: double.infinity,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          ),
        ),
        const SizedBox(height: _kPaddingBelow),
      ],
    );
  }
}
