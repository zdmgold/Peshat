import 'package:flutter/cupertino.dart';
import 'banner_ad_widget.dart';

/// Shared bottom ad slot used on every screen.
///
/// Owns only the top-level hide logic:
///   1. The user has purchased ad removal (mirrors [PurchaseProvider]).
///   2. A software keyboard is visible (MediaQuery.viewInsetsOf bottom > 0).
///
/// All visual chrome — padding, radius, shadow, reservation — lives inside
/// [BannerAdWidget], gated on whether an ad is loaded. When the ad is not
/// yet loaded or has failed, the entire slot collapses to zero height and
/// nothing is drawn.
class AdSlot extends StatelessWidget {
  const AdSlot({super.key});

  static final ValueNotifier<bool> _purchased = ValueNotifier<bool>(false);

  /// Called from main.dart whenever the purchase state changes.
  static void setPurchased(bool value) => _purchased.value = value;

  @override
  Widget build(BuildContext context) {
    final keyboardUp = MediaQuery.viewInsetsOf(context).bottom > 0;
    return ValueListenableBuilder<bool>(
      valueListenable: _purchased,
      builder: (context, purchased, _) {
        if (purchased || keyboardUp) return const SizedBox.shrink();
        return const BannerAdWidget();
      },
    );
  }
}
