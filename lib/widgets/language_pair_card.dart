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
  final String? sourceSubtitle;
  final VoidCallback onTapSource;
  final String destinationLabel;
  final String destinationValue;
  final String? destinationSubtitle;
  final VoidCallback onTapDestination;

  const LanguagePairCard({
    super.key,
    required this.sourceLabel,
    required this.sourceValue,
    this.sourceSubtitle,
    required this.onTapSource,
    required this.destinationLabel,
    required this.destinationValue,
    this.destinationSubtitle,
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
      child: IntrinsicHeight(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Half(
              label: sourceLabel,
              value: sourceValue,
              subtitle: sourceSubtitle,
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
                subtitle: destinationSubtitle,
                onTap: onTapDestination,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _Half extends StatefulWidget {
  final String label;
  final String value;
  final String? subtitle;
  final VoidCallback onTap;
  const _Half({
    required this.label,
    required this.value,
    required this.onTap,
    this.subtitle,
  });

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
      label: '${widget.label}, ${widget.value}'
          '${widget.subtitle == null ? '' : ', ${widget.subtitle}'}',
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
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  // Large text can round up 1 px past the measured height;
                  // let it spill into the 8 px padding instead of overflowing.
                  child: OverflowBox(
                    alignment: AlignmentDirectional.topStart,
                    minHeight: 0,
                    maxHeight: double.infinity,
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
                      const SizedBox(height: 2),
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
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                    ],
                  ),
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
