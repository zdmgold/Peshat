import 'package:flutter/cupertino.dart';
import '../core/services/review_prompt.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../l10n/app_localizations.dart';

/// Dismissible "Enjoying Peshat?" card shown on the home screen (see
/// [ReviewPrompt] for when).
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    return ValueListenableBuilder<bool>(
      valueListenable: ReviewPrompt.instance.visible,
      builder: (context, show, _) {
        if (!show) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.bgSecondaryDark
                : AppColors.bgSecondaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reviewCardTitle,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.reviewCardSubtitle,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 32,
                      onPressed: ReviewPrompt.instance.rate,
                      child: Text(l10n.rateAppLabel),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                minSize: 44,
                onPressed: ReviewPrompt.instance.dismiss,
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 18,
                  semanticLabel: l10n.closeButtonTooltip,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
