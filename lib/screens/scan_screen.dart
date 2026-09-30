import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import '../core/models/app_theme_mode.dart';
import '../core/models/scan_result.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/ui_locale_provider.dart';
import '../core/providers/notification_provider.dart';
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
  final NotificationProvider notification;

  const ScanScreen({
    super.key,
    required this.theme,
    required this.purchase,
    required this.settings,
    required this.history,
    required this.uiLocale,
    required this.notification,
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
          notification: widget.notification,
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
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: const SizedBox.shrink(),
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
                child: const PeshatIcon(icon: AppIcons.globe, size: 24),
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
                  child: PeshatIcon(
                    icon: mode == AppThemeMode.dark
                        ? AppIcons.sun
                        : AppIcons.moon,
                    size: 24,
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
                child: const PeshatIcon(icon: AppIcons.settings, size: 24),
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
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.lg),
                    Text(
                      l10n.appName,
                      textAlign: TextAlign.left,
                      style: AppTypography.brand.copyWith(
                        fontSize: 34,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),

                    // Primary action — circular scan button
                    Center(
                      child: GestureDetector(
                        onTap: _isScanning ? null : _handleScan,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.28),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isScanning
                                ? const CupertinoActivityIndicator(
                                    radius: 16,
                                    color: Color(0xFFFFFFFF),
                                  )
                                : const PeshatIcon(
                                    icon: AppIcons.scanDocument,
                                    size: 56,
                                    color: Color(0xFFFFFFFF),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        l10n.scanShortLabel,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),

                    // Secondary actions — three text rows
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 44,
                      onPressed: _openTextTranslate,
                      child: Text(
                        l10n.typeTextButtonLabel,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 44,
                      onPressed: _handleImport,
                      child: Text(
                        l10n.importFileLabel,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: widget.settings,
                      builder: (_, code, __) => CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 44,
                        onPressed: _pickTargetLanguage,
                        child: Text(
                          '${l10n.translateToLabel}: ${languageDisplayName(code)}',
                          style: AppTypography.chrome.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),

                    // RECENT — inline section, max 3 rows
                    ValueListenableBuilder<List<ScanResult>>(
                      valueListenable: widget.history,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return const SizedBox(height: Spacing.xl);
                        }
                        final preview = items.take(3).toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.xs,
                                bottom: Spacing.sm,
                              ),
                              child: Text(
                                l10n.recentLabel.toUpperCase(),
                                style: AppTypography.chrome.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: textTertiary,
                                ),
                              ),
                            ),
                            for (int i = 0; i < preview.length; i++)
                              _RecentRow(
                                result: preview[i],
                                isDark: isDark,
                                isLast: i == preview.length - 1,
                                onTap: () => _openHistory(),
                              ),
                            const SizedBox(height: Spacing.xl),
                          ],
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

// ---------------------------------------------------------------------------
// Recent-row preview — mirrors the History screen's row layout, no delete
// ---------------------------------------------------------------------------

class _RecentRow extends StatefulWidget {
  final ScanResult result;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _RecentRow({
    required this.result,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_RecentRow> createState() => _RecentRowState();
}

class _RecentRowState extends State<_RecentRow> {
  bool _pressed = false;

  String _timeLabel(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final textTertiary = widget.isDark
        ? AppColors.textTertiaryDark
        : AppColors.textTertiaryLight;
    final border = widget.isDark
        ? AppColors.borderSubtleDark
        : AppColors.borderSubtleLight;

    final timeLabel = _timeLabel(widget.result.timestamp);
    final chipLabel =
        '${widget.result.sourceLang.toUpperCase()} → ${widget.result.targetLang.toUpperCase()}';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Text(
                  timeLabel,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 12,
                    color: textTertiary,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? AppColors.bgTertiaryDark
                        : AppColors.bgTertiaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    chipLabel,
                    style: AppTypography.sourceChip.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.result.sourceText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.chrome.copyWith(
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.result.translatedText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            if (!widget.isLast)
              Padding(
                padding: const EdgeInsets.only(left: Spacing.xs),
                child: Container(height: 0.5, color: border),
              ),
          ],
        ),
      ),
    );
  }
}
