import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/models/scan_result.dart';
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
import 'text_translate_screen.dart';
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
  bool _isScanning = false;

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          theme: widget.theme,
          purchase: widget.purchase,
          settings: widget.settings,
          history: widget.history,
          uiLocale: widget.uiLocale,
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

  Future<void> _openTextTranslate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TextTranslateScreen(
          settings: widget.settings,
          history: widget.history,
        ),
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

  void _openStored(ScanResult r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          inputText: r.sourceText,
          initialTargetLanguage: r.targetLang,
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
            titleSpacing: Spacing.md,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 28,
                    height: 28,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  l10n.appName,
                  style: AppTypography.brand.copyWith(
                    fontSize: 24,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
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
                        const SizedBox(height: Spacing.md),

                        // Hero — logo + wordmark + tagline
                        Center(
                          child: Image.asset(
                            'assets/icon/icon.png',
                            width: 88,
                            height: 88,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Text(
                          l10n.appName,
                          textAlign: TextAlign.center,
                          style: AppTypography.brand.copyWith(
                            fontSize: 34,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          l10n.tagline,
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),

                        // Scan cluster — big circular button + Type text pill
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _ScanCircleButton(
                              onTap: _isScanning ? null : _handleScan,
                              isScanning: _isScanning,
                              isDark: isDark,
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: _TypeTextPill(
                                label: l10n.typeTextButtonLabel,
                                onTap: _openTextTranslate,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),

                        // Import row
                        SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _handleImport,
                            icon: const Icon(Icons.upload_file_outlined,
                                size: 20),
                            label: Text(l10n.importFileLabel),
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),

                        // Target language card
                        _LanguageCard(
                          label: l10n.translateToLabel,
                          settings: widget.settings,
                          onTap: _pickTargetLanguage,
                          isDark: isDark,
                        ),
                        const SizedBox(height: Spacing.lg),

                        // Recent scan preview
                        ValueListenableBuilder<List<ScanResult>>(
                          valueListenable: widget.history,
                          builder: (context, items, _) {
                            if (items.isEmpty) return const SizedBox.shrink();
                            final last = items.first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      l10n.recentScansLabel,
                                      style: AppTypography.chrome.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.4,
                                        color: isDark
                                            ? AppColors.textTertiaryDark
                                            : AppColors.textTertiaryLight,
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
                                Card(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () => _openStored(last),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Spacing.md),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            last.sourceText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                AppTypography.chrome.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? AppColors.textPrimaryDark
                                                  : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            last.translatedText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.body.copyWith(
                                              fontSize: 13,
                                              color: isDark
                                                  ? AppColors
                                                      .textSecondaryDark
                                                  : AppColors
                                                      .textSecondaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (!adsRemoved)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: BannerAdWidget(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ScanCircleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isScanning;
  final bool isDark;

  const _ScanCircleButton({
    required this.onTap,
    required this.isScanning,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return Semantics(
      label: 'Scan',
      button: true,
      child: Material(
        color: accent,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: accent.withValues(alpha: 0.5),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 120,
            height: 120,
            child: Center(
              child: isScanning
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(
                      Icons.document_scanner_outlined,
                      color: Colors.white,
                      size: 44,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeTextPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _TypeTextPill({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.bgSecondaryDark
                : AppColors.bgSecondaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent, width: 1.2),
          ),
          child: Row(
            children: [
              Icon(Icons.edit_note, color: accent, size: 24),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String label;
  final SettingsProvider settings;
  final VoidCallback onTap;
  final bool isDark;

  const _LanguageCard({
    required this.label,
    required this.settings,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bgSecondaryDark
              : AppColors.bgSecondaryLight,
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
            Icon(
              Icons.translate,
              size: 20,
              color: isDark ? AppColors.accentDark : AppColors.accentLight,
            ),
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
              child: ValueListenableBuilder<String>(
                valueListenable: settings,
                builder: (_, code, __) => Text(
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
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
