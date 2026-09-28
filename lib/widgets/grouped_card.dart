import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';

/// iOS-style grouped container. Children are stacked vertically with
/// hairline dividers between them (not above the first or below the last),
/// inset from the leading edge.
class GroupedCard extends StatelessWidget {
  final List<Widget> children;
  const GroupedCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark
        ? AppColors.borderSubtleDark
        : AppColors.borderSubtleLight;

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(Divider(
          height: 0.5,
          thickness: 0.5,
          indent: Spacing.md,
          endIndent: 0,
          color: border,
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: rows,
        ),
      ),
    );
  }
}

/// Single row inside a [GroupedCard]. Height is at least 56dp
/// (or 64dp when a subtitle is present). Tap state uses the standard
/// Material ink well.
class GroupedRow extends StatelessWidget {
  final IconData? leading;
  final Color? leadingColor;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final IconData? trailingIcon;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool showChevron;

  const GroupedRow({
    super.key,
    this.leading,
    this.leadingColor,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailingIcon,
    this.trailingWidget,
    this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final minBody = hasSubtitle ? 48.0 : 40.0;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minBody),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              Icon(
                leading,
                size: 22,
                color: leadingColor ?? textSecondary,
              ),
              const SizedBox(width: Spacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                    ),
                  ),
                  if (hasSubtitle) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              const SizedBox(width: Spacing.sm),
              Text(
                trailingText!,
                style: AppTypography.chrome.copyWith(
                  fontSize: 15,
                  color: textTertiary,
                ),
              ),
            ],
            if (trailingIcon != null) ...[
              const SizedBox(width: Spacing.sm),
              Icon(trailingIcon, size: 20, color: textTertiary),
            ],
            if (trailingWidget != null) ...[
              const SizedBox(width: Spacing.sm),
              trailingWidget!,
            ],
            if (showChevron) ...[
              const SizedBox(width: Spacing.xs),
              Icon(Icons.chevron_right, size: 20, color: textTertiary),
            ],
          ],
        ),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: accent.withValues(alpha: 0.08),
        highlightColor: accent.withValues(alpha: 0.04),
        child: content,
      ),
    );
  }
}
