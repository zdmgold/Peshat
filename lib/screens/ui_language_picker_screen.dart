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

    final sorted = [...supportedLanguages]..sort((a, b) =>
        a.englishName.toLowerCase().compareTo(b.englishName.toLowerCase()));

    // Build a flat list of rows: System row, then section label, then
    // languages with a small non-sticky letter label before each new letter.
    final rows = <Widget>[];

    rows.add(_SectionLabel(
      text: l10n.sectionSystemLabel,
      color: textTertiary,
    ));
    rows.add(_UiLanguageRow(
      leading: Icons.smartphone,
      title: 'Follow system',
      subtitle: null,
      selected: current == null,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      accent: accent,
      onTap: () => Navigator.pop(context, 'system'),
    ));
    rows.add(const SizedBox(height: Spacing.md));
    rows.add(_SectionLabel(
      text: l10n.appLanguageLabel,
      color: textTertiary,
    ));

    String? lastLetter;
    for (final lang in sorted) {
      final letter = lang.englishName.substring(0, 1).toUpperCase();
      if (letter != lastLetter) {
        lastLetter = letter;
        rows.add(_LetterLabel(letter: letter, color: textTertiary));
      }
      final selected = current?.languageCode == lang.code;
      rows.add(_UiLanguageRow(
        leading: null,
        title: lang.nativeName,
        subtitle: lang.englishName,
        nativeIsRtl: lang.isRtl,
        selected: selected,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        accent: accent,
        onTap: () => Navigator.pop(context, lang.code),
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
              child: ListView(
                padding: const EdgeInsets.only(bottom: Spacing.xl),
                children: rows,
              ),
            ),
            const AdSlot(),
          ],
        ),
      ),
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
