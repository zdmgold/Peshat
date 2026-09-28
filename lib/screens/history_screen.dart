import 'package:flutter/material.dart';
import '../core/models/scan_result.dart';
import '../core/providers/history_provider.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryProvider history;
  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.historyLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<List<ScanResult>>(
            valueListenable: history,
            builder: (context, items, _) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.more_horiz, size: 22),
                    tooltip: MaterialLocalizations.of(context)
                        .showMenuTooltip,
                    onPressed: () =>
                        _showOverflowSheet(context, l10n),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<ScanResult>>(
                valueListenable: history,
                builder: (context, items, _) {
                  if (items.isEmpty) {
                    return _EmptyState(
                      l10n: l10n,
                      isDark: isDark,
                    );
                  }
                  final grouped = _groupByDate(items, l10n);
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: Spacing.sm,
                      bottom: Spacing.xl,
                    ),
                    itemCount: _sectionItemCount(grouped),
                    itemBuilder: (context, i) =>
                        _buildItem(context, i, grouped, l10n, isDark),
                  );
                },
              ),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Grouping
  // -------------------------------------------------------------------------

  Map<String, List<ScanResult>> _groupByDate(
    List<ScanResult> items,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final today = <ScanResult>[];
    final yesterday = <ScanResult>[];
    final older = <ScanResult>[];
    for (final r in items) {
      final d = now.difference(r.timestamp).inDays;
      if (d == 0) {
        today.add(r);
      } else if (d == 1) {
        yesterday.add(r);
      } else {
        older.add(r);
      }
    }
    final map = <String, List<ScanResult>>{};
    if (today.isNotEmpty) map[l10n.historyToday] = today;
    if (yesterday.isNotEmpty) map[l10n.historyYesterday] = yesterday;
    if (older.isNotEmpty) map[l10n.historyOlder] = older;
    return map;
  }

  // -------------------------------------------------------------------------
  // List assembly — for each section: one header + N rows
  // -------------------------------------------------------------------------

  int _sectionItemCount(Map<String, List<ScanResult>> grouped) {
    var count = 0;
    for (final entry in grouped.entries) {
      count += 1 + entry.value.length;
    }
    return count;
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Map<String, List<ScanResult>> grouped,
    AppLocalizations l10n,
    bool isDark,
  ) {
    var cursor = 0;
    for (final entry in grouped.entries) {
      if (index == cursor) {
        return _SectionHeader(label: entry.key, isDark: isDark);
      }
      final sectionStart = cursor + 1;
      final sectionEnd = sectionStart + entry.value.length;
      if (index >= sectionStart && index < sectionEnd) {
        final r = entry.value[index - sectionStart];
        final isLastInSection = index == sectionEnd - 1;
        return _HistoryRow(
          result: r,
          isDark: isDark,
          isLast: isLastInSection,
          onTap: () => _open(context, r),
          onDelete: () => history.delete(r.id),
        );
      }
      cursor = sectionEnd;
    }
    return const SizedBox.shrink();
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

  // -------------------------------------------------------------------------
  // Overflow sheet — a single destructive action
  // -------------------------------------------------------------------------

  Future<void> _showOverflowSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final error = isDark ? AppColors.errorDark : AppColors.errorLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final sheetBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.sm),
            ListTile(
              leading: Icon(Icons.delete_sweep_outlined,
                  size: 22, color: error),
              title: Text(
                l10n.clearHistoryLabel,
                style: AppTypography.chrome.copyWith(
                  fontSize: 16,
                  color: error,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmClear(context, l10n);
              },
            ),
            const SizedBox(height: Spacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    MaterialLocalizations.of(ctx).cancelButtonLabel,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
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
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.lg,
        Spacing.md,
        Spacing.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.chrome.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: textTertiary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row — 72dp flat, timestamp + language chip, source, translation.
// ---------------------------------------------------------------------------

class _HistoryRow extends StatelessWidget {
  final ScanResult result;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryRow({
    required this.result,
    required this.isDark,
    required this.isLast,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final error = isDark ? AppColors.errorDark : AppColors.errorLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    final timeLabel = _timeLabel(result.timestamp);
    final chipLabel =
        '${result.sourceLang.toUpperCase()} → ${result.targetLang.toUpperCase()}';

    return Dismissible(
      key: ValueKey(result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        color: error,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row 1: time + bullet + language chip
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
                            color: isDark
                                ? AppColors.bgTertiaryDark
                                : AppColors.bgTertiaryLight,
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
                    // Row 2: source text
                    Text(
                      result.sourceText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Row 3: translation
                    Text(
                      result.translatedText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: Spacing.md),
                  child: Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: border,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;

  const _EmptyState({required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_toggle_off, size: 56, color: textTertiary),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.historyEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.chrome.copyWith(
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.historyEmptySubtitle,
              textAlign: TextAlign.center,
              style: AppTypography.chrome.copyWith(
                fontSize: 14,
                color: textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
