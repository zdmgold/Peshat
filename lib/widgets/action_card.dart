import 'package:flutter/cupertino.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_icons.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import 'peshat_icon.dart';

/// A filled tappable card with a leading icon, a label, and an optional
/// trailing value and chevron.
///
/// Used for:
///   - Home's two secondary actions (Type text, Import a file):
///     icon + label, no value, no chevron
///   - Text translate's target language row:
///     icon + label + value + chevron
///   - Result's translation chip:
///     icon + label + value + chevron
class ActionCard extends StatefulWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String? value;
  final bool showChevron;
  final VoidCallback onTap;
  final double minHeight;

  const ActionCard({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.showChevron = false,
    required this.onTap,
    this.minHeight = 56,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1.0,
        child: Container(
          constraints: BoxConstraints(minHeight: widget.minHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Row(
            children: [
              PeshatIcon(icon: widget.icon, size: 22, color: accent),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ),
              if (widget.value != null) ...[
                const SizedBox(width: Spacing.sm),
                Flexible(
                  child: Text(
                    widget.value!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
              if (widget.showChevron) ...[
                const SizedBox(width: Spacing.sm),
                PeshatIcon(
                  icon: AppIcons.chevronForward,
                  size: 16,
                  color: textTertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A transparent tappable row with a leading icon, inline label, and a
/// trailing chevron. Press state fills the row with bgTertiary for 100ms.
///
/// Used for the language selector rows on Home and Text translate, which
/// read as inline controls rather than as cards.
class ActionRow extends StatefulWidget {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final double minHeight;

  const ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.minHeight = 56,
  });

  @override
  State<ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<ActionRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final pressedBg =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        constraints: BoxConstraints(minHeight: widget.minHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: _pressed ? pressedBg : const Color(0x00000000),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            PeshatIcon(icon: widget.icon, size: 22, color: accent),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.chrome.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            PeshatIcon(
              icon: AppIcons.chevronForward,
              size: 16,
              color: textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
