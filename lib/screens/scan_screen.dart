import 'package:flutter/material.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../platform/document_scanner_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'language_picker_screen.dart';
import 'result_screen.dart';
import 'settings_screen.dart';

class ScanScreen extends StatefulWidget {
  final ThemeProvider theme;
  final PurchaseProvider purchase;
  final SettingsProvider settings;
  final HistoryProvider history;

  const ScanScreen({
    super.key,
    required this.theme,
    required this.purchase,
    required this.settings,
    required this.history,
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
        ),
      ),
    );
  }

  Future<void> _pickLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(current: widget.settings.value),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
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
      // Cancellation or scanner failure; nothing to show.
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.purchase,
      builder: (context, adsRemoved, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appName),
            actions: [
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
                const Spacer(flex: 2),

                Semantics(
                  label: l10n.semanticsAppIcon,
                  child: Icon(
                    Icons.document_scanner_outlined,
                    size: 72,
                    color: isDark
                        ? AppColors.accentDark
                        : AppColors.accentLight,
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                Text(
                  l10n.appName,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 30,
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
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),

                const SizedBox(height: Spacing.xl),

                Semantics(
                  label: l10n.semanticsScanButton,
                  child: SizedBox(
                    width: 220,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _handleScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.accentDark
                            : AppColors.accentLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isScanning
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n.scanButtonLabel,
                              style: AppTypography.chrome.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: Spacing.lg),

                ValueListenableBuilder<String>(
                  valueListenable: widget.settings,
                  builder: (context, code, _) => InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _pickLanguage,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.sm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.translate,
                            size: 18,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            '${l10n.changeLanguageButton}: ',
                            style: AppTypography.chrome.copyWith(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            languageDisplayName(code),
                            style: AppTypography.chrome.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),
                if (!adsRemoved) const BannerAdWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
