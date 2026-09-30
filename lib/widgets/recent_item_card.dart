import 'package:flutter/cupertino.dart';
import '../core/models/scan_result.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_icons.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import 'peshat_icon.dart';

/// A card that renders a single [ScanResult] as a preview tile.
///
/// Used on Home. Shows three rows of content:
///   1. Timestamp + language-pair chip
///   2. Source text
///   3. Translation
///
/// The trailing chevron is top-aligned with the timestamp row, not
/// vertically centred, so it reads as part of the metadata cluster
/// rather than as a floating element.
///
/// Empty sourceText falls back to translatedText; the caller is
/// responsible for not rendering the widget at all when both are empty.
class RecentItemCard extends StatefulWidget {
  final ScanResult result;
  final VoidCallback onTap;

  const RecentItemCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  State<RecentItemCard> createState() => _RecentItemCardState();
}

class _RecentItemCardState extends State<RecentItemCard> {
  bool _pressed = false;

  String _timeLabel(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final chipBg =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;

    final timeLabel = _timeLabel(widget.result.timestamp);
    final chipLabel =
        '${widget.result.sourceLang.toUpperCase()} → ${widget.result.targetLang.toUpperCase()}';

    final sourceText = widget.result.sourceText.trim();
    final translatedText = widget.result.translatedText.trim();
    final hasSource = sourceText.isNotEmpty;
    final hasTranslated = translatedText.isNotEmpty;

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
          constraints: const BoxConstraints(minHeight: 80),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row 1 — timestamp · dot · language chip
                    Row(
                      children: [
                        Text(
                          timeLabel,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 12,
                            color: textTertiary,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: textTertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            chipLabel,
                            style: AppTypography.sourceChip.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Row 2 — source text, or translated fallback
                    Text(
                      hasSource ? sourceText : translatedText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 15,
                        color: textPrimary,
                      ),
                    ),
                    // Row 3 — translated text, only when source was present
                    if (hasSource && hasTranslated) ...[
                      const SizedBox(height: 4),
                      Text(
                        translatedText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              // Trailing chevron — top-aligned with row 1
              PeshatIcon(
                icon: AppIcons.chevronForward,
                size: 16,
                color: textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
