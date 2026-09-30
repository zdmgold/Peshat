import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: peshatBackButton(context, color: textPrimary),
        middle: Text(
          l10n.historyLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        trailing: ValueListenableBuilder<List<ScanResult>>(
          valueListenable: history,
          builder: (context, items, _) => items.isEmpty
              ? const SizedBox.shrink()
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 44,
                  onPressed: () => _showOverflowSheet(context, l10n),
                  child: Semantics(
                    label: l10n.showMenuTooltip,
                    button: true,
                    child: const PeshatIcon(icon: AppIcons.more, size: 22),
                  ),
                ),
        ),
      ),
      child: SafeArea(
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
      CupertinoPageRoute(
        builder: (_) => ResultScreen(
          inputText: r.sourceText,
          initialTargetLanguage: r.targetLang,
          history: history,
        ),
      ),
    );
  }

  Future<void> _showOverflowSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              _confirmClear(context, l10n);
            },
            child: Text(l10n.clearHistoryLabel),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancelButtonLabel),
        ),
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Text(l10n.historyClearConfirm),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButtonLabel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.okButtonLabel),
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
// History row — iOS press feedback, Dismissible for swipe-to-delete
// ---------------------------------------------------------------------------

class _HistoryRow extends StatefulWidget {
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
  State<_HistoryRow> createState() => _HistoryRowState();
}

class _HistoryRowState extends State<_HistoryRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final textTertiary = widget.isDark
        ? AppColors.textTertiaryDark
        : AppColors.textTertiaryLight;
    final error =
        widget.isDark ? AppColors.errorDark : AppColors.errorLight;
    final border = widget.isDark
        ? AppColors.borderSubtleDark
        : AppColors.borderSubtleLight;

    final timeLabel = _timeLabel(widget.result.timestamp);
    final chipLabel =
        '${widget.result.sourceLang.toUpperCase()} → ${widget.result.targetLang.toUpperCase()}';

    return Dismissible(
      key: ValueKey(widget.result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        color: error,
        child: const PeshatIcon(icon: AppIcons.delete,
            color: Color(0xFFFFFFFF), size: 24),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: _pressed ? 0.6 : 1.0,
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
                            color: widget.isDark
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
                    Text(
                      widget.result.sourceText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.result.translatedText,
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
              if (!widget.isLast)
                Padding(
                  padding: const EdgeInsets.only(left: Spacing.md),
                  child: Container(
                    height: 0.5,
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
            PeshatIcon(icon: AppIcons.history, size: 56, color: textTertiary),
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
