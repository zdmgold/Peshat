import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/utils/app_icons.dart';
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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
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
            Padding(
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
            Expanded(
              child: filtered.isEmpty
                  ? _EmptySearchState(
                      title: l10n.noResults,
                      subtitle: l10n.noResultsSubtitle,
                      isDark: isDark,
                    )
                  : _buildList(
                      context,
                      filtered: filtered,
                      recents: recents,
                      l10n: l10n,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textTertiary: textTertiary,
                      accent: accent,
                    ),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context, {
    required List<Language> filtered,
    required List<Language> recents,
    required AppLocalizations l10n,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
    required Color accent,
  }) {
    final rows = <Widget>[];

    if (recents.isNotEmpty) {
      rows.add(_SectionLabel(
        text: l10n.recentLanguagesLabel,
        color: textTertiary,
      ));
      for (final lang in recents) {
        rows.add(_Row(
          language: lang,
          selected: lang.code == widget.current,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          accent: accent,
          onTap: () => Navigator.pop(context, lang.code),
        ));
      }
      rows.add(const SizedBox(height: Spacing.md));
      rows.add(_SectionLabel(
        text: l10n.allLanguagesLabel,
        color: textTertiary,
      ));
    }

    String? lastLetter;
    for (final lang in filtered) {
      final letter = lang.englishName.substring(0, 1).toUpperCase();
      if (letter != lastLetter) {
        lastLetter = letter;
        rows.add(_LetterLabel(letter: letter, color: textTertiary));
      }
      rows.add(_Row(
        language: lang,
        selected: lang.code == widget.current,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        accent: accent,
        onTap: () => Navigator.pop(context, lang.code),
      ));
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: Spacing.xl),
      children: rows,
    );
  }
}

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
                  HugeIcon(icon: AppIcons.check,
                      size: 20, color: widget.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
            HugeIcon(icon: AppIcons.search, size: 48, color: textTertiary),
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
