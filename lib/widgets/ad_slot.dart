import 'package:flutter/material.dart';
import 'banner_ad_widget.dart';

/// Shared bottom ad slot used on every screen.
///
/// Reads a static purchase flag that mirrors [PurchaseProvider] — no
/// constructor plumbing, no provider wiring per screen. Hides itself
/// when:
///   1. The user has purchased ad removal.
///   2. A software keyboard is visible (MediaQuery.viewInsetsOf bottom > 0),
///      because there is no room for content + keyboard + ad on any phone.
///
/// Otherwise renders [BannerAdWidget], which reserves a fixed 60dp slot
/// so the page never reflows when the ad loads.
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
