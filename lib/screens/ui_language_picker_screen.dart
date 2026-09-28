import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';

class UiLanguagePickerScreen extends StatelessWidget {
  final Locale? current;
  const UiLanguagePickerScreen({super.key, this.current});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final bg = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;

    // Sort alphabetically by English name
    final sorted = [...supportedLanguages]..sort((a, b) =>
        a.englishName.toLowerCase().compareTo(b.englishName.toLowerCase()));

    // Group by first letter
    final byLetter = <String, List<Language>>{};
    for (final l in sorted) {
      final letter = l.englishName.substring(0, 1).toUpperCase();
      byLetter.putIfAbsent(letter, () => []).add(l);
    }
    final sortedLetters = byLetter.keys.toList()..sort();

    final slivers = <Widget>[];

    // SYSTEM section
    slivers.add(_sectionHeader(l10n.sectionSystemLabel, bg, textTertiary));
    slivers.add(SliverToBoxAdapter(
      child: _UiLanguageRow(
        leading: Icons.smartphone,
        title: 'Follow system',
        subtitle: null,
        selected: current == null,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        accent: accent,
        onTap: () => Navigator.pop(context, 'system'),
      ),
    ));

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: Spacing.md)));

    // APP LANGUAGE section
    slivers.add(_sectionHeader(l10n.appLanguageLabel, bg, textTertiary));

    for (final letter in sortedLetters) {
      slivers.add(SliverPersistentHeader(
        pinned: true,
        delegate: _LetterHeaderDelegate(
          letter: letter,
          bgColor: bg,
          textStyle: AppTypography.chrome.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: textTertiary,
          ),
        ),
      ));
      slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final lang = byLetter[letter]![i];
            final selected = current?.languageCode == lang.code;
            return _UiLanguageRow(
              leading: null,
              title: lang.nativeName,
              subtitle: lang.englishName,
              nativeIsRtl: lang.isRtl,
              selected: selected,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              accent: accent,
              onTap: () => Navigator.pop(context, lang.code),
            );
          },
          childCount: byLetter[letter]!.length,
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.uiLanguageLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(slivers: slivers),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _sectionHeader(String label, Color bg, Color color) {
    return SliverToBoxAdapter(
      child: Container(
        color: bg,
        padding: const EdgeInsets.fromLTRB(
          Spacing.md,
          Spacing.md,
          Spacing.md,
          Spacing.sm,
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.chrome.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _LetterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String letter;
  final Color bgColor;
  final TextStyle textStyle;

  _LetterHeaderDelegate({
    required this.letter,
    required this.bgColor,
    required this.textStyle,
  });

  @override
  double get minExtent => 32;
  @override
  double get maxExtent => 32;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bgColor,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Text(letter, style: textStyle),
    );
  }

  @override
  bool shouldRebuild(covariant _LetterHeaderDelegate old) =>
      old.letter != letter || old.bgColor != bgColor;
}

class _UiLanguageRow extends StatelessWidget {
  final IconData? leading;
  final String title;
  final String? subtitle;
  final bool nativeIsRtl;
  final bool selected;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final VoidCallback onTap;

  const _UiLanguageRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.nativeIsRtl = false,
    required this.selected,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final semanticsLabel = subtitle == null ? title : '$title, $subtitle';
    return Semantics(
      label: semanticsLabel,
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  Icon(leading, size: 22, color: textSecondary),
                  const SizedBox(width: Spacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textDirection: nativeIsRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          color: textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
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
                if (selected) Icon(Icons.check, size: 20, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
