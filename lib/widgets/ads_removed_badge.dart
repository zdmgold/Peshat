import 'package:flutter/cupertino.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';

class AdsRemovedBadge extends StatelessWidget {
  const AdsRemovedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: isDark ? AppColors.accentDark : AppColors.accentLight,
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      child: Text(
        l10n.adsRemovedBadge,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
