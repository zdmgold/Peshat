import 'package:flutter/material.dart';
import '../core/models/scan_result.dart';
import '../core/providers/history_provider.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

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
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: l10n.historyClearConfirm,
                    onPressed: () => _confirmClear(context, l10n),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<ScanResult>>(
          valueListenable: history,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return _EmptyState(isDark: isDark, l10n: l10n);
            }
            final grouped = _group(items);
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              children: [
                for (final section in grouped.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Spacing.md, Spacing.md, Spacing.md, Spacing.xs),
                    child: Text(
                      section.key,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                  ),
                  ...section.value.map((r) => _HistoryTile(
                        result: r,
                        onOpen: () => _open(context, r),
                        onDelete: () => history.delete(r.id),
                      )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, AppLocalizations l10n) async {
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
  }

  void _open(BuildContext context, ScanResult r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          inputText: r.sourceText,
          initialTargetLanguage: r.targetLang,
          history: history,
        ),
      ),
    );
  }

  Map<String, List<ScanResult>> _group(List<ScanResult> items) {
    final ctx = _DateBucket();
    final now = DateTime.now();
    final today = <ScanResult>[];
    final yesterday = <ScanResult>[];
    final older = <ScanResult>[];
    for (final r in items) {
      final diff = now.difference(r.timestamp).inDays;
      if (diff == 0) {
        today.add(r);
      } else if (diff == 1) {
        yesterday.add(r);
      } else {
        older.add(r);
      }
    }
    final map = <String, List<ScanResult>>{};
    if (today.isNotEmpty) map[ctx.today] = today;
    if (yesterday.isNotEmpty) map[ctx.yesterday] = yesterday;
    if (older.isNotEmpty) map[ctx.older] = older;
    return map;
  }
}

class _DateBucket {
  String today = 'Today';
  String yesterday = 'Yesterday';
  String older = 'Older';
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  const _EmptyState({required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 56,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.historyEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  const _HistoryTile({
    required this.result,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dismissible(
      key: ValueKey(result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        color: isDark ? AppColors.errorDark : AppColors.errorLight,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md, vertical: Spacing.xs),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _timeLabel(result.timestamp),
                          style: AppTypography.chrome.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.4,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.bgTertiaryDark
                              : AppColors.bgTertiaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${result.sourceLang.toUpperCase()} → ${result.targetLang.toUpperCase()}',
                          style: AppTypography.sourceChip.copyWith(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    result.sourceText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    result.translatedText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm  •  ${languageDisplayName(_localeCode())}';
  }

  String _localeCode() => 'en';
}
