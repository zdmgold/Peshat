import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';

class UiLanguagePickerScreen extends StatelessWidget {
  final Locale? current;
  const UiLanguagePickerScreen({super.key, this.current});

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
    final l10n = AppLocalizations.of(context)!;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    final sorted = [...supportedLanguages]
      ..sort((a, b) =>
          a.englishName.toLowerCase().compareTo(b.englishName.toLowerCase()));
    final groups = _groupByLetter(sorted);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: peshatBackButton(context, color: textPrimary),
        middle: Text(
          l10n.uiLanguageLabel,
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
                  // SYSTEM section — header + Follow system row.
                  SliverToBoxAdapter(
                    child: _SectionLabel(
                      text: l10n.sectionSystemLabel,
                      color: textTertiary,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _UiLanguageRow(
                      leading: AppIcons.smartphone,
                      title: 'Follow system',
                      subtitle: null,
                      selected: current == null,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      accent: accent,
                      onTap: () => Navigator.pop(context, 'system'),
                    ),
                  ),

                  // APP LANGUAGE section header.
                  SliverToBoxAdapter(
                    child: _SectionLabel(
                      text: l10n.appLanguageLabel,
                      color: textTertiary,
                    ),
                  ),

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
                        (context, i) => _UiLanguageRow(
                          leading: null,
                          title: group.languages[i].nativeName,
                          subtitle: group.languages[i].englishName,
                          nativeIsRtl: group.languages[i].isRtl,
                          selected: current?.languageCode ==
                              group.languages[i].code,
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
// Letter group — internal data structure for the sectioned list.
// ---------------------------------------------------------------------------

class _LetterGroup {
  final String letter;
  final List<Language> languages;
  const _LetterGroup(this.letter, this.languages);
}

// ---------------------------------------------------------------------------
// Section label — SYSTEM / APP LANGUAGE headers, not sticky.
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
// Row — iOS press feedback
// ---------------------------------------------------------------------------

class _UiLanguageRow extends StatefulWidget {
  final List<List<dynamic>>? leading;
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
  State<_UiLanguageRow> createState() => _UiLanguageRowState();
}

class _UiLanguageRowState extends State<_UiLanguageRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final semanticsLabel = widget.subtitle == null
        ? widget.title
        : '${widget.title}, ${widget.subtitle}';
    return Semantics(
      label: semanticsLabel,
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
                if (widget.leading != null) ...[
                  PeshatIcon(
                    icon: widget.leading!,
                    size: 22,
                    color: widget.textSecondary,
                  ),
                  const SizedBox(width: Spacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        textDirection: widget.nativeIsRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          color: widget.textPrimary,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 13,
                            color: widget.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.selected)
                  PeshatIcon(
                    icon: AppIcons.check,
                    size: 20,
                    color: widget.accent,
                  ),
              ],
            ),
          ),
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
