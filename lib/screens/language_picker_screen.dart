import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/services/translator_service.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';

class LanguagePickerScreen extends StatefulWidget {
  final String? current;
  const LanguagePickerScreen({super.key, this.current});

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final filtered = supportedLanguages
        .where((l) => TranslatorService.isTranslatable(l.code))
        .where((l) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return l.englishName.toLowerCase().contains(q) ||
          l.nativeName.toLowerCase().contains(q) ||
          l.code.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguageTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Semantics(
                label: l10n.semanticsSearchField,
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.searchLanguagesHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.bgTertiaryDark
                        : AppColors.bgTertiaryLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noResults,
                        style: AppTypography.body.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final lang = filtered[i];
                        final selected = lang.code == widget.current;
                        return ListTile(
                          leading: Text(
                            lang.nativeName,
                            textDirection: lang.isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: AppTypography.chrome.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          title: Text(
                            lang.englishName,
                            style: AppTypography.chrome.copyWith(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          trailing: selected
                              ? Icon(
                                  Icons.check,
                                  color: isDark
                                      ? AppColors.accentDark
                                      : AppColors.accentLight,
                                )
                              : null,
                          onTap: () => Navigator.pop(context, lang.code),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
