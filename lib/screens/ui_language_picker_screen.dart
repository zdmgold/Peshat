import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/locale_resolution.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';
import '../widgets/alpha_index.dart';

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

    final sorted = supportedLanguages
        .where((l) => isUiLanguageSupported(l.code))
        .toList()
      ..sort((a, b) =>
          a.englishName.toLowerCase().compareTo(b.englishName.toLowerCase()));
    final groups = _groupByLetter(sorted);

    // Rows have a fixed height so the A-Z index can jump to a letter; grow it
    // with the text size. Emulator, real fonts: a row overflowed by 5 px at
    // 100% text and 19 px at 130%, section labels by 9 px and letters by 4 px
    // at 130%.
    final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final rowExtent = (16 + 53 * textScale) > _kRowExtent
        ? (16 + 53 * textScale)
        : _kRowExtent;
    final extra = textScale > 1 ? textScale - 1 : 0.0;
    final labelExtent = _kLabelExtent + 35 * extra;
    final letterExtent = _kLetterExtent + 15 * extra;

    final entries = <IndexEntry>[
      IndexEntry(
        extent: labelExtent,
        child: _SectionLabel(
          text: l10n.sectionSystemLabel,
          color: textTertiary,
        ),
      ),
      IndexEntry(
        extent: rowExtent,
        child: _UiLanguageRow(
          leading: AppIcons.smartphone,
          title: l10n.followSystemLabel,
          subtitle: null,
          selected: current == null,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          accent: accent,
          onTap: () => Navigator.pop(context, 'system'),
        ),
      ),
      IndexEntry(
        extent: labelExtent,
        child: _SectionLabel(
          text: l10n.appLanguageLabel,
          color: textTertiary,
        ),
      ),
      for (final group in groups) ...[
        IndexEntry(
          extent: letterExtent,
          letter: group.letter,
          child: _LetterLabel(letter: group.letter, color: textTertiary),
        ),
        for (final lang in group.languages)
          IndexEntry(
            extent: rowExtent,
            child: _UiLanguageRow(
              leading: null,
              title: lang.nativeName,
              subtitle: lang.englishName == lang.nativeName ? null : lang.englishName,
              nativeIsRtl: lang.isRtl,
              selected: current?.languageCode == lang.code,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              accent: accent,
              onTap: () => Navigator.pop(context, lang.code),
            ),
          ),
      ],
    ];

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
              child: AlphaIndexedList(
                entries: entries,
                letterColor: accent,
              ),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }
}

const double _kRowExtent = 64;
const double _kLabelExtent = 40;
const double _kLetterExtent = 32;

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
            color: widget.selected
                ? widget.accent.withValues(alpha: 0.10)
                : null,
            padding: const EdgeInsetsDirectional.fromSTEB(
              Spacing.md,
              Spacing.sm,
              28,
              Spacing.sm,
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
