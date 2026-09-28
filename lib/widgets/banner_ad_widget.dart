import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/utils/app_colors.dart';

// Google's official test banner unit ID. Replace before release.
const String _kBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

const double _kSlotHeight = 60;
const double _kHorizontalInset = 8;

/// Reserved-height banner ad slot.
///
/// Always renders a fixed-height container, whether the ad loads or not.
/// This eliminates the layout reflow that used to push the whole screen
/// upward when the ad arrived a few seconds after first frame.
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
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _kBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || _isDisposed) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted || _isDisposed) return;
          setState(() => _isLoaded = false);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;

    final showAd = _isLoaded && _bannerAd != null;

    return Container(
      height: _kSlotHeight,
      margin: const EdgeInsets.symmetric(horizontal: _kHorizontalInset),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: showAd
            ? const [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: showAd
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox.shrink(),
    );
  }
}


