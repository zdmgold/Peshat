import 'package:flutter/cupertino.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_icons.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import 'peshat_icon.dart';

/// One card with two tappable halves: the source language (what the photo is
/// written in) and the destination language (what it is translated into).
/// Each half carries its own label.
class LanguagePairCard extends StatelessWidget {
  final String sourceLabel;
  final String sourceValue;
  final VoidCallback onTapSource;
  final String destinationLabel;
  final String destinationValue;
  final VoidCallback onTapDestination;

  const LanguagePairCard({
    super.key,
    required this.sourceLabel,
    required this.sourceValue,
    required this.onTapSource,
    required this.destinationLabel,
    required this.destinationValue,
    required this.onTapDestination,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Half(
              label: sourceLabel,
              value: sourceValue,
              onTap: onTapSource,
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(color: border, width: 0.5),
                ),
              ),
              child: _Half(
                label: destinationLabel,
                value: destinationValue,
                onTap: onTapDestination,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Half extends StatefulWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _Half({required this.label, required this.value, required this.onTap});

  @override
  State<_Half> createState() => _HalfState();
}

class _HalfState extends State<_Half> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    return Semantics(
      button: true,
      label: '${widget.label}, ${widget.value}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: _pressed ? 0.6 : 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 11,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                PeshatIcon(
                  icon: AppIcons.chevronForward,
                  size: 14,
                  color: textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
