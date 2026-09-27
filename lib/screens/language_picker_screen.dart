import 'package:flutter/material.dart';
import '../core/models/language.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/spacing.dart';

class LanguagePickerScreen extends StatefulWidget {
  const LanguagePickerScreen({super.key});

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
    final filtered = supportedLanguages.where((lang) => 
      lang.englishName.toLowerCase().contains(_query.toLowerCase()) ||
      lang.nativeName.toLowerCase().contains(_query.toLowerCase()) // FIX: Case-insensitive
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Language')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Semantics(
              label: 'Search languages',
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search languages...',
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
                  label: '${lang.englishName}, ${lang.nativeName}',
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
