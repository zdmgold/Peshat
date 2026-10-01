import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
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

class _LetterGroup {
  final String letter;
  final List<Language> languages;
  const _LetterGroup(this.letter, this.languages);
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Language> get _all {
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

  List<Language> _recentList(List<Language> all) {
    if (_query.isNotEmpty) return const [];
    final byCode = {for (final l in all) l.code: l};
    final seen = <String>{};
    final out = <Language>[];
    for (final code in widget.recents) {
      if (code == widget.current) continue;
      if (!seen.add(code)) continue;
      final l = byCode[code];
      if (l != null) out.add(l);
    }
    return out;
  }

  List<_LetterGroup> _groupByLetter(List<Language> languages) {
    final groups = <_LetterGroup>[];
    String? currentLetter;
    var currentList = <Language>[];
    for (final lang in languages) {
      final letter = lang.englishName.substring(0, 1).toUpperCase();
      if (letter != currentLetter) {
        if (currentList.isNotEmpty) {
          groups.add(_LetterGroup(currentLetter!, currentList));
        }
        currentLetter = letter;
        currentList = [lang];
      } else {
        currentList.add(lang);
      }
    }
    if (currentList.isNotEmpty) {
      groups.add(_LetterGroup(currentLetter!, currentList));
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final inputFill =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;

    final all = _all;
    final filtered = _filtered(all);
    final recents = _recentList(all);
    final groups = _groupByLetter(filtered);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: peshatBackButton(context, color: textPrimary),
        middle: Text(
          l10n.selectLanguageTitle,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Search field — scrolls away with the list.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.md,
                        Spacing.sm,
                        Spacing.md,
                        Spacing.sm,
                      ),
                      child: CupertinoSearchTextField(
                        controller: _search,
                        onChanged: (v) => setState(() => _query = v),
                        placeholder: l10n.searchLanguagesHint,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 15,
                          color: textPrimary,
                        ),
                        placeholderStyle: AppTypography.chrome.copyWith(
                          fontSize: 15,
                          color: textTertiary,
                        ),
                        cursorColor: accent,
                        itemColor: textTertiary,
                        backgroundColor: inputFill,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),

                  // Empty search state.
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptySearchState(
                        title: l10n.noResults,
                        subtitle: l10n.noResultsSubtitle,
                        isDark: isDark,
                      ),
                    )
                  else ...[
                    // RECENT section — only when not searching.
                    if (recents.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionLabel(
                          text: l10n.recentLanguagesLabel,
                          color: textTertiary,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _Row(
                            language: recents[i],
                            selected: recents[i].code == widget.current,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            accent: accent,
                            onTap: () =>
                                Navigator.pop(context, recents[i].code),
                          ),
                          childCount: recents.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _SectionLabel(
                          text: l10n.allLanguagesLabel,
                          color: textTertiary,
                        ),
                      ),
                    ],

                    // Letter-grouped sections with sticky headers.
                    for (final group in groups) ...[
                      SliverToBoxAdapter(
                        child: _LetterLabel(
                          letter: group.letter,
                          color: textTertiary,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _Row(
                            language: group.languages[i],
                            selected:
                                group.languages[i].code == widget.current,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            accent: accent,
                            onTap: () => Navigator.pop(
                              context,
                              group.languages[i].code,
                            ),
                          ),
                          childCount: group.languages.length,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(
                      child: SizedBox(height: Spacing.xl),
                    ),
                  ],
                ],
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
// Section label — RECENT / ALL LANGUAGES headers, not sticky.
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.md,
        Spacing.md,
        Spacing.xs,
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.chrome.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row
// ---------------------------------------------------------------------------

class _Row extends StatefulWidget {
  final Language language;
  final bool selected;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final VoidCallback onTap;

  const _Row({
    required this.language,
    required this.selected,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_Row> createState() => _RowState();
}

class _RowState extends State<_Row> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${widget.language.englishName}, ${widget.language.nativeName}',
      button: true,
      selected: widget.selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: _pressed ? 0.6 : 1.0,
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
                        widget.language.nativeName,
                        textDirection: widget.language.isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          color: widget.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.language.englishName,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 13,
                          color: widget.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.selected)
                  PeshatIcon(icon: AppIcons.check,
                      size: 20, color: widget.accent),
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

class _EmptySearchState extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _EmptySearchState({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

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
            PeshatIcon(icon: AppIcons.search, size: 48, color: textTertiary),
            const SizedBox(height: Spacing.md),
            Text(
              title,
              style: AppTypography.chrome.copyWith(
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              subtitle,
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

// ---------------------------------------------------------------------------
// Letter label — inline (non-sticky) header above a letter group.
// ---------------------------------------------------------------------------

class _LetterLabel extends StatelessWidget {
  final String letter;
  final Color color;
  const _LetterLabel({required this.letter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.sm,
        Spacing.md,
        Spacing.xs,
      ),
      child: Text(
        letter,
        style: AppTypography.chrome.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
