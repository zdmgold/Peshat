import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/ui_locale_provider.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../platform/document_scanner_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'history_screen.dart';
import 'language_picker_screen.dart';
import 'result_screen.dart';
import 'settings_screen.dart';
import 'ui_language_picker_screen.dart';

class ScanScreen extends StatefulWidget {
  final ThemeProvider theme;
  final PurchaseProvider purchase;
  final SettingsProvider settings;
  final HistoryProvider history;
  final UiLocaleProvider uiLocale;

  const ScanScreen({
    super.key,
    required this.theme,
    required this.purchase,
    required this.settings,
    required this.history,
    required this.uiLocale,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final DocumentScannerService _scanner = DocumentScannerService();
  final TextEditingController _text = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          theme: widget.theme,
          purchase: widget.purchase,
          settings: widget.settings,
          history: widget.history,
        ),
      ),
    );
  }

  Future<void> _openHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryScreen(history: widget.history),
      ),
    );
  }

  Future<void> _pickTargetLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(current: widget.settings.value),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
  }

  Future<void> _pickUiLanguage() async {
    final selected = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => UiLanguagePickerScreen(current: widget.uiLocale.value),
      ),
    );
    if (selected == null) return;
    if (selected == 'system') {
      widget.uiLocale.setLocale(null);
    } else if (selected is String) {
      widget.uiLocale.setLocale(Locale(selected));
    }
  }

  Future<void> _toggleTheme() async {
    final current = widget.theme.value;
    final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    widget.theme.setMode(next);
  }

  Future<void> _handleScan() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    try {
      final paths = await _scanner.scan();
      if (!mounted || paths.isEmpty) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imagePath: paths.first,
            initialTargetLanguage: widget.settings.value,
            history: widget.history,
          ),
        ),
      );
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _handleImport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'txt'],
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null || !mounted) return;
      final ext = path.split('.').last.toLowerCase();
      if (ext == 'txt') {
        final text = await File(path).readAsString();
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              inputText: text,
              initialTargetLanguage: widget.settings.value,
              history: widget.history,
            ),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              imagePath: path,
              initialTargetLanguage: widget.settings.value,
              history: widget.history,
            ),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _handleText() async {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    _text.clear();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          inputText: text,
          initialTargetLanguage: widget.settings.value,
          history: widget.history,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.purchase,
      builder: (context, adsRemoved, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appName),
            actions: [
              IconButton(
                icon: const Icon(Icons.translate),
                tooltip: l10n.uiLanguageLabel,
                onPressed: _pickUiLanguage,
              ),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.theme,
                builder: (_, mode, __) => IconButton(
                  icon: Icon(mode == ThemeMode.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined),
                  tooltip: l10n.themeLabel,
                  onPressed: _toggleTheme,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.folder_outlined),
                tooltip: l10n.historyLabel,
                onPressed: _openHistory,
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: l10n.settingsTitle,
                onPressed: _openSettings,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: Spacing.sm),

                        // Hero
                        Icon(
                          Icons.document_scanner_outlined,
                          size: 56,
                          color: isDark
                              ? AppColors.accentDark
                              : AppColors.accentLight,
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          l10n.appName,
                          textAlign: TextAlign.center,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          l10n.tagline,
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),

                        // Target language
                        _LanguageCard(
                          label: l10n.translateToLabel,
                          code: widget.settings.value,
                          onTap: _pickTargetLanguage,
                          settings: widget.settings,
                        ),
                        const SizedBox(height: Spacing.md),

                        // Text input
                        TextField(
                          controller: _text,
                          minLines: 3,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: l10n.typeTextLabel,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.arrow_forward,
                                  color: isDark
                                      ? AppColors.accentDark
                                      : AppColors.accentLight),
                              onPressed: _handleText,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.md),

                        // Scan + import row
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: _isScanning ? null : _handleScan,
                                  icon: _isScanning
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.camera_alt_outlined,
                                          size: 20),
                                  label: Text(l10n.scanButtonLabel),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: _handleImport,
                                  icon: const Icon(Icons.upload_file_outlined,
                                      size: 20),
                                  label: Text(l10n.importFileLabel),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Spacing.xl),

                        // Recent scans
                        ValueListenableBuilder(
                          valueListenable: widget.history,
                          builder: (context, items, _) {
                            if (items.isEmpty) return const SizedBox.shrink();
                            final recent = items.take(3).toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      l10n.recentScansLabel,
                                      style: AppTypography.chrome.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: _openHistory,
                                      child: Text(l10n.seeAllLabel),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Spacing.xs),
                                ...recent.map((r) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: Spacing.sm),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                            r.sourceText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.chrome
                                                .copyWith(fontSize: 14),
                                          ),
                                          subtitle: Text(
                                            r.translatedText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.body
                                                .copyWith(fontSize: 13),
                                          ),
                                          trailing: Text(
                                            '${r.sourceLang.toUpperCase()} → ${r.targetLang.toUpperCase()}',
                                            style:
                                                AppTypography.sourceChip.copyWith(
                                              fontSize: 11,
                                              color: isDark
                                                  ? AppColors.textTertiaryDark
                                                  : AppColors.textTertiaryLight,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (!adsRemoved) const BannerAdWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String label;
  final String code;
  final VoidCallback onTap;
  final SettingsProvider settings;

  const _LanguageCard({
    required this.label,
    required this.code,
    required this.onTap,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder<String>(
      valueListenable: settings,
      builder: (context, code, _) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md, vertical: Spacing.sm),
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? AppColors.borderSubtleDark
                  : AppColors.borderSubtleLight,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.translate,
                  size: 20,
                  color: isDark ? AppColors.accentDark : AppColors.accentLight),
              const SizedBox(width: Spacing.md),
              Text(
                label,
                style: AppTypography.chrome.copyWith(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  languageDisplayName(code),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Icon(Icons.chevron_right,
                  size: 20,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight),
            ],
          ),
        ),
      ),
    );
  }
}
