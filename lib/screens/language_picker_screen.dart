import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/services/translator_service.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';

class LanguagePickerScreen extends StatefulWidget {
  final String? current;
  final List<String> recents;

  const LanguagePickerScreen({
    super.key,
    this.current,
    this.recents = const [],
  });

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Language> get _allTranslatable {
    final list = supportedLanguages
        .where((l) => TranslatorService.isTranslatable(l.code))
        .toList()
      ..sort((a, b) =>
          a.englishName.toLowerCase().compareTo(b.englishName.toLowerCase()));
    return list;
  }

  List<Language> _filtered(List<Language> source) {
    if (_query.isEmpty) return source;
    final q = _query.toLowerCase();
    return source
        .where((l) =>
            l.englishName.toLowerCase().contains(q) ||
            l.nativeName.toLowerCase().contains(q) ||
            l.code.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    final all = _allTranslatable;
    final filtered = _filtered(all);

    // Recent list excludes the current selection and duplicates
    final recentsSet = <String>{};
    final recentList = <Language>[];
    if (_query.isEmpty) {
      final byCode = {for (final l in all) l.code: l};
      for (final code in widget.recents) {
        if (code == widget.current) continue;
        if (!recentsSet.add(code)) continue;
        final lang = byCode[code];
        if (lang != null) recentList.add(lang);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectLanguageTitle,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.sm,
                Spacing.md,
                Spacing.sm,
              ),
              child: Semantics(
                label: l10n.semanticsSearchField,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.bgTertiaryDark
                        : AppColors.bgTertiaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 20, color: textTertiary),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: (v) => setState(() => _query = v),
                          style: AppTypography.chrome.copyWith(
                            fontSize: 15,
                            color: textPrimary,
                          ),
                          cursorColor: accent,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            filled: false,
                            hintText: l10n.searchLanguagesHint,
                            hintStyle: AppTypography.chrome.copyWith(
                              fontSize: 15,
                              color: textTertiary,
                            ),
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                          child: Icon(Icons.close,
                              size: 18, color: textTertiary),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Body
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(
                      l10n: l10n,
                      textSecondary: textSecondary,
                      textTertiary: textTertiary,
                    )
                  : _ListBody(
                      recents: recentList,
                      all: filtered,
                      current: widget.current,
                      isDark: isDark,
                      l10n: l10n,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textTertiary: textTertiary,
                      accent: accent,
                      onPick: (code) => Navigator.pop(context, code),
                    ),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List body — Recent section (if any) + All languages section with sticky
// letter headers.
// ---------------------------------------------------------------------------

class _ListBody extends StatelessWidget {
  final List<Language> recents;
  final List<Language> all;
  final String? current;
  final bool isDark;
  final AppLocalizations l10n;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final void Function(String code) onPick;

  const _ListBody({
    required this.recents,
    required this.all,
    required this.current,
    required this.isDark,
    required this.l10n,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.onPick,
  });

  Map<String, List<Language>> get _byLetter {
    final map = <String, List<Language>>{};
    for (final l in all) {
      final letter = l.englishName.substring(0, 1).toUpperCase();
      map.putIfAbsent(letter, () => []).add(l);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;

    final slivers = <Widget>[];

    // Recent section
    if (recents.isNotEmpty) {
      slivers.add(_sectionHeader(l10n.recentLanguagesLabel, bg));
      slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => _LanguageRow(
            language: recents[i],
            selected: recents[i].code == current,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            accent: accent,
            onTap: () => onPick(recents[i].code),
          ),
          childCount: recents.length,
        ),
      ));
      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: Spacing.md)));
    }

    // All languages header
    slivers.add(_sectionHeader(l10n.allLanguagesLabel, bg));

    // Letter sections
    final byLetter = _byLetter;
    for (final entry in byLetter.entries) {
      slivers.add(SliverPersistentHeader(
        pinned: true,
        delegate: _LetterHeaderDelegate(
          letter: entry.key,
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
            final lang = entry.value[i];
            return _LanguageRow(
              language: lang,
              selected: lang.code == current,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              accent: accent,
              onTap: () => onPick(lang.code),
            );
          },
          childCount: entry.value.length,
        ),
      ));
    }

    return CustomScrollView(slivers: slivers);
  }

  SliverToBoxAdapter _sectionHeader(String label, Color bg) {
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
            color: textTertiary,
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

// ---------------------------------------------------------------------------
// Row — native name + English name stacked, checkmark for current.
// ---------------------------------------------------------------------------

class _LanguageRow extends StatelessWidget {
  final Language language;
  final bool selected;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${language.englishName}, ${language.nativeName}',
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language.nativeName,
                        textDirection: language.isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        language.englishName,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check, size: 20, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty search state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  final Color textSecondary;
  final Color textTertiary;

  const _EmptyState({
    required this.l10n,
    required this.textSecondary,
    required this.textTertiary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: textTertiary),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.noResults,
              textAlign: TextAlign.center,
              style: AppTypography.chrome.copyWith(
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              l10n.noResultsSubtitle,
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
