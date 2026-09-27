import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';

class SourceTextChip extends StatelessWidget {
  final String languageCode;
  final double confidence;

  const SourceTextChip({
    super.key,
    required this.languageCode,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight,
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageCode.toUpperCase(),
            style: AppTypography.sourceChip.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            '${(confidence * 100).toInt()}%',
            style: AppTypography.sourceChip.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
