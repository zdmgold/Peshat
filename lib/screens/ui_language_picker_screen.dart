import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../l10n/app_localizations.dart';

class UiLanguagePickerScreen extends StatelessWidget {
  final Locale? current;
  const UiLanguagePickerScreen({super.key, this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.uiLanguageLabel)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.smartphone_outlined),
              title: const Text('Follow system'),
              trailing: current == null
                  ? Icon(Icons.check,
                      color: isDark
                          ? AppColors.accentDark
                          : AppColors.accentLight)
                  : null,
              onTap: () => Navigator.pop(context, 'system'),
            ),
            const Divider(height: 0.5),
            ...supportedLanguages.map((l) {
              final selected = current?.languageCode == l.code;
              return ListTile(
                leading: Text(
                  l.nativeName,
                  textDirection:
                      l.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                title: Text(
                  l.englishName,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                trailing: selected
                    ? Icon(Icons.check,
                        color: isDark
                            ? AppColors.accentDark
                            : AppColors.accentLight)
                    : null,
                onTap: () => Navigator.pop(context, l.code),
              );
            }),
          ],
        ),
      ),
    );
  }
}

