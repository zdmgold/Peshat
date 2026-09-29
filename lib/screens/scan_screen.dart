import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../core/models/app_theme_mode.dart';
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
import '../widgets/ad_slot.dart';
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
      CupertinoPageRoute(
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
      CupertinoPageRoute(
        builder: (_) => HistoryScreen(history: widget.history),
      ),
    );
  }

  Future<void> _openTextTranslate() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
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
      CupertinoPageRoute(
        builder: (_) => LanguagePickerScreen(
          current: widget.settings.value,
          recents: widget.settings.recentTargets,
        ),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
  }

  Future<void> _pickUiLanguage() async {
    final selected = await Navigator.push<dynamic>(
      context,
      CupertinoPageRoute(
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
    final next = widget.theme.value == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;
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
        CupertinoPageRoute(
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
          CupertinoPageRoute(
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
          CupertinoPageRoute(
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
    final brightness = CupertinoTheme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Row(
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44,
              onPressed: _pickUiLanguage,
              child: Semantics(
                label: l10n.uiLanguageLabel,
                button: true,
                child: const Icon(CupertinoIcons.globe, size: 22),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            ValueListenableBuilder<AppThemeMode>(
              valueListenable: widget.theme,
              builder: (_, mode, __) => CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 44,
                onPressed: _toggleTheme,
                child: Semantics(
                  label: l10n.themeLabel,
                  button: true,
                  child: Icon(
                    mode == AppThemeMode.dark
                        ? CupertinoIcons.sun_max
                        : CupertinoIcons.moon,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44,
              onPressed: _openSettings,
              child: Semantics(
                label: l10n.settingsTitle,
                button: true,
                child: const Icon(CupertinoIcons.gear, size: 22),
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.md),
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
                        fontSize: 32,
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
                        fontSize: 14,
                        height: 1.5,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),

                    SizedBox(
                      height: 56,
                      child: CupertinoButton.filled(
                        padding: EdgeInsets.zero,
                        onPressed: _isScanning ? null : _handleScan,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isScanning)
                              const CupertinoActivityIndicator(
                                radius: 10,
                                color: Color(0xFFFFFFFF),
                              )
                            else
                              const Icon(
                                CupertinoIcons.doc_text_viewfinder,
                                size: 22,
                                color: Color(0xFFFFFFFF),
                              ),
                            const SizedBox(width: Spacing.sm),
                            Text(
                              l10n.scanButtonLabel,
                              style: AppTypography.chrome.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: _OutlinedActionButton(
                            icon: CupertinoIcons.pencil,
                            label: l10n.typeTextButtonLabel,
                            accent: accent,
                            onPressed: _openTextTranslate,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: _OutlinedActionButton(
                            icon: CupertinoIcons.arrow_up_doc,
                            label: l10n.importFileLabel,
                            accent: accent,
                            onPressed: _handleImport,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),

                    _CardRow(
                      leading: CupertinoIcons.globe,
                      label: l10n.translateToLabel,
                      trailing: ValueListenableBuilder<String>(
                        valueListenable: widget.settings,
                        builder: (_, code, __) => Text(
                          languageDisplayName(code),
                          style: AppTypography.chrome.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      onTap: _pickTargetLanguage,
                      isDark: isDark,
                    ),
                    const SizedBox(height: Spacing.md),

                    ValueListenableBuilder<List<ScanResult>>(
                      valueListenable: widget.history,
                      builder: (context, items, _) {
                        if (items.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.md),
                          child: _CardRow(
                            leading: CupertinoIcons.time,
                            label: l10n.recentScansLabel,
                            trailing: Text(
                              '${items.length}',
                              style: AppTypography.chrome.copyWith(
                                fontSize: 15,
                                color: textSecondary,
                              ),
                            ),
                            onTap: _openHistory,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const AdSlot(),
          ],
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onPressed;

  const _OutlinedActionButton({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: accent),
              const SizedBox(width: Spacing.sm),
              Text(
                label,
                style: AppTypography.chrome.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardRow extends StatefulWidget {
  final IconData leading;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;
  final bool isDark;

  const _CardRow({
    required this.leading,
    required this.label,
    required this.trailing,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<_CardRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark
        ? AppColors.bgSecondaryDark
        : AppColors.bgSecondaryLight;
    final border = widget.isDark
        ? AppColors.borderSubtleDark
        : AppColors.borderSubtleLight;
    final textSecondary = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final textTertiary = widget.isDark
        ? AppColors.textTertiaryDark
        : AppColors.textTertiaryLight;
    final accent =
        widget.isDark ? AppColors.accentDark : AppColors.accentLight;

    return GestureDetector(
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
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Row(
            children: [
              Icon(widget.leading, size: 22, color: accent),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    color: textSecondary,
                  ),
                ),
              ),
              widget.trailing,
              const SizedBox(width: Spacing.sm),
              Icon(CupertinoIcons.chevron_forward,
                  size: 20, color: textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
