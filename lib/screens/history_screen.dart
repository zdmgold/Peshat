import 'package:flutter/material.dart';
import '../core/models/scan_result.dart';
import '../core/providers/history_provider.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryProvider history;
  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyLabel),
        actions: [
          ValueListenableBuilder<List<ScanResult>>(
            valueListenable: history,
            builder: (context, items, _) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: Text(l10n.historyClearConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await history.clear();
                    },
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<ScanResult>>(
          valueListenable: history,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history,
                          size: 56,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight),
                      const SizedBox(height: Spacing.md),
                      Text(l10n.historyEmpty,
                          textAlign: TextAlign.center,
                          style: AppTypography.chrome.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
              itemBuilder: (context, i) {
                final r = items[i];
                return Card(
                  color: isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      width: 0.5,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(Spacing.md),
                    title: Text(
                      r.sourceText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.chrome.copyWith(fontSize: 14),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        r.translatedText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body.copyWith(fontSize: 14),
                      ),
                    ),
                    trailing: Text(
                      r.sourceLang.toUpperCase(),
                      style: AppTypography.sourceChip.copyWith(
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
