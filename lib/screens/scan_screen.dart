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
import '../widgets/grouped_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.purchase,
      builder: (context, adsRemoved, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: Spacing.md,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 26,
                    height: 26,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  l10n.appName,
                  style: AppTypography.brand.copyWith(
                    fontSize: 22,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.language, size: 22),
                tooltip: l10n.uiLanguageLabel,
                onPressed: _pickUiLanguage,
              ),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.theme,
                builder: (_, mode, __) => IconButton(
                  icon: Icon(
                    mode == ThemeMode.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    size: 22,
                  ),
                  tooltip: l10n.themeLabel,
                  onPressed: _toggleTheme,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 22),
                tooltip: l10n.settingsTitle,
                onPressed: _openSettings,
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: Spacing.lg),

                        // Hero
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              width: 72,
                              height: 72,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          l10n.appName,
                          textAlign: TextAlign.center,
                          style: AppTypography.brand.copyWith(
                            fontSize: 34,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          l10n.tagline,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body.copyWith(
                            fontSize: 15,
                            height: 1.5,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),

                        // Input card — hero surface
                        _InputCard(
                          placeholder: l10n.typeTextLabel,
                          onTapBody: _openTextTranslate,
                          onTapCamera: _isScanning ? null : _handleScan,
                          onTapUpload: _handleImport,
                          isScanning: _isScanning,
                          isDark: isDark,
                          accent: accent,
                          border: border,
                        ),
                        const SizedBox(height: Spacing.lg),

                        // Grouped action card
                        GroupedCard(
                          children: [
                            GroupedRow(
                              leading: Icons.document_scanner_outlined,
                              title: l10n.cameraLabel,
                              onTap: _isScanning ? null : _handleScan,
                              showChevron: true,
                            ),
                            GroupedRow(
                              leading: Icons.upload_file_outlined,
                              title: l10n.importFileLabel,
                              onTap: _handleImport,
                              showChevron: true,
                            ),
                            ValueListenableBuilder<List<ScanResult>>(
                              valueListenable: widget.history,
                              builder: (context, items, _) => GroupedRow(
                                leading: Icons.history,
                                title: l10n.recentScansLabel,
                                trailingText: items.isEmpty
                                    ? null
                                    : '${items.length}',
                                onTap: _openHistory,
                                showChevron: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.lg),

                        // Target language card
                        _LanguageRow(
                          label: l10n.translateToLabel,
                          settings: widget.settings,
                          onTap: _pickTargetLanguage,
                          isDark: isDark,
                          border: border,
                          accent: accent,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: Spacing.lg),
                      ],
                    ),
                  ),
                ),
                if (!adsRemoved) const BannerAdWidget() else const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Input card — primary surface, tap body opens the text editor,
// camera and upload icons are accessories.
// ---------------------------------------------------------------------------

class _InputCard extends StatelessWidget {
  final String placeholder;
  final VoidCallback onTapBody;
  final VoidCallback? onTapCamera;
  final VoidCallback onTapUpload;
  final bool isScanning;
  final bool isDark;
  final Color accent;
  final Color border;

  const _InputCard({
    required this.placeholder,
    required this.onTapBody,
    required this.onTapCamera,
    required this.onTapUpload,
    required this.isScanning,
    required this.isDark,
    required this.accent,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTapBody,
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.chrome.copyWith(
                  fontSize: 16,
                  color: textTertiary,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MiniIconButton(
                      icon: Icons.upload_file_outlined,
                      color: accent,
                      onTap: onTapUpload,
                      tooltip: 'Import',
                    ),
                    const SizedBox(width: Spacing.sm),
                    _MiniIconButton(
                      icon: Icons.camera_alt_outlined,
                      color: accent,
                      onTap: onTapCamera,
                      tooltip: 'Camera',
                      isLoading: isScanning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String tooltip;
  final bool isLoading;

  const _MiniIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    )
                  : Icon(icon, size: 22, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Target language row — full-width card with label + value + chevron.
// ---------------------------------------------------------------------------

class _LanguageRow extends StatelessWidget {
  final String label;
  final SettingsProvider settings;
  final VoidCallback onTap;
  final bool isDark;
  final Color border;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;

  const _LanguageRow({
    required this.label,
    required this.settings,
    required this.onTap,
    required this.isDark,
    required this.border,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Row(
            children: [
              Icon(Icons.translate, size: 22, color: accent),
              const SizedBox(width: Spacing.md),
              Text(
                label,
                style: AppTypography.chrome.copyWith(
                  fontSize: 15,
                  color: textSecondary,
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<String>(
                valueListenable: settings,
                builder: (_, code, __) => Text(
                  languageDisplayName(code),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Icon(Icons.chevron_right, size: 20, color: textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
