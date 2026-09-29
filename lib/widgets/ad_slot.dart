import 'package:flutter/cupertino.dart';
import '../core/utils/app_colors.dart';
import 'banner_ad_widget.dart';

/// Padding values from the batch 10 decisions.
const double _kSideInset = 8;
const double _kPaddingAbove = 8;
const double _kPaddingBelow = 4;
const double _kTopRadius = 12;
const double _kShadowBlur = 8;
const double _kShadowYOffset = 2;
const double _kShadowAlpha = 0.5;

/// Shared bottom ad slot used on every screen.
///
/// Owns the padding, radius and shadow around [BannerAdWidget]. Hides
/// itself and all of its reserved space when:
///   1. The user has purchased ad removal (mirrors [PurchaseProvider]).
///   2. A software keyboard is visible (MediaQuery.viewInsetsOf bottom > 0).
class AdSlot extends StatelessWidget {
  const AdSlot({super.key});

  static final ValueNotifier<bool> _purchased = ValueNotifier<bool>(false);

  /// Called from main.dart whenever the purchase state changes.
  static void setPurchased(bool value) => _purchased.value = value;

  @override
  Widget build(BuildContext context) {
    final keyboardUp = MediaQuery.viewInsetsOf(context).bottom > 0;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cream = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;

    return ValueListenableBuilder<bool>(
      valueListenable: _purchased,
      builder: (context, purchased, _) {
        if (purchased || keyboardUp) return const SizedBox.shrink();

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
                child: const ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(_kTopRadius),
                  ),
                  child: BannerAdWidget(),
                ),
              ),
            ),
            const SizedBox(height: _kPaddingBelow),
          ],
        );
      },
    );
  }
}
