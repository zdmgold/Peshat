import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';

class LanguagePickerScreen extends StatefulWidget {
  final String? current;
  const LanguagePickerScreen({super.key, this.current});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final filtered = supportedLanguages
        .where((lang) =>
            lang.englishName.toLowerCase().contains(_query.toLowerCase()) ||
            lang.nativeName.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguageTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Semantics(
              label: l10n.semanticsSearchField,
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l10n.searchLanguagesHint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final lang = filtered[index];
                return Semantics(
                  label: l10n.semanticsLanguageEntry(lang.englishName, lang.nativeName),
                  child: ListTile(
                    leading: const Text('🏳️', style: TextStyle(fontSize: 24)),
                    title: Text(
                      lang.nativeName,
                      textDirection: lang.isRtl ? TextDirection.rtl : TextDirection.ltr,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(lang.englishName, style: const TextStyle(fontSize: 12)),
                    onTap: () => Navigator.pop(context, lang.code),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
