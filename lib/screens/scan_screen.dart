import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../widgets/action_card.dart';
import '../widgets/ad_slot.dart';
import '../widgets/recent_item_card.dart';
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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // ─── Toolbar ────────────────────────────────────────────────
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Row(
                  children: [
                    Text(
                      l10n.appName,
                      style: AppTypography.brand.copyWith(
                        fontSize: 26,
                        color: textPrimary,
                      ),
                    ),
                    const Spacer(),
                    _ChipButton(
                      icon: AppIcons.globe,
                      semanticLabel: l10n.uiLanguageLabel,
                      isDark: isDark,
                      onPressed: _pickUiLanguage,
                    ),
                    const SizedBox(width: Spacing.sm),
                    ValueListenableBuilder<AppThemeMode>(
                      valueListenable: widget.theme,
                      builder: (_, mode, __) => _ChipButton(
                        icon: mode == AppThemeMode.dark
                            ? AppIcons.sun
                            : AppIcons.moon,
                        semanticLabel: l10n.themeLabel,
                        isDark: isDark,
                        onPressed: _toggleTheme,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    _ChipButton(
                      icon: AppIcons.settings,
                      semanticLabel: l10n.settingsTitle,
                      isDark: isDark,
                      onPressed: _openSettings,
                    ),
                  ],
                ),
              ),
            ),

            // ─── Content — fixed layout, no scrolling ───────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tagline — centered in the space between toolbar and
                    // scan button. Absorbs whatever vertical slack the
                    // screen has, so it always sits in the middle of that
                    // gap.
                    Expanded(
                      child: Center(
                        child: Text(
                          l10n.tagline,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.brand.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ),

                    // Primary action — brass L mark on cream page.
                    _ScanLogo(
                      label: l10n.scanShortLabel,
                      isScanning: _isScanning,
                      onTap: _handleScan,
                    ),
                    const SizedBox(height: 32),

                    // Secondary action cards
                    Row(
                      children: [
                        Expanded(
                          child: ActionCard(
                            icon: AppIcons.typeText,
                            label: l10n.typeTextButtonLabel,
                            onTap: _openTextTranslate,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: ActionCard(
                            icon: AppIcons.importFile,
                            label: l10n.importFileLabel,
                            onTap: _handleImport,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Language selector — filled card.
                    ActionCard(
                      icon: AppIcons.globe,
                      label: l10n.translateToLabel,
                      value: languageDisplayName(widget.settings.value),
                      showChevron: true,
                      onTap: _pickTargetLanguage,
                    ),
                    const SizedBox(height: 32),

                    // RECENT section — fixed 80px card, hidden when empty.
                    ValueListenableBuilder<List<ScanResult>>(
                      valueListenable: widget.history,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.xs,
                                bottom: Spacing.sm,
                              ),
                              child: Text(
                                '${l10n.recentLabel.toUpperCase()} · ${items.length}',
                                style: AppTypography.chrome.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: textTertiary,
                                ),
                              ),
                            ),
                            RecentItemCard(
                              result: items.first,
                              onTap: _openHistory,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ─── Ad slot ────────────────────────────────────────────────
            const AdSlot(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar chip — 40×40 with bgSecondary fill, 12 radius, icon centred
// ---------------------------------------------------------------------------

class _ChipButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String semanticLabel;
  final bool isDark;
  final VoidCallback onPressed;

  const _ChipButton({
    required this.icon,
    required this.semanticLabel,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final iconColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Semantics(
      label: semanticLabel,
      button: true,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 40,
        onPressed: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: PeshatIcon(icon: icon, size: 22, color: iconColor),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Primary action — brass L mark on cream, no card, no fill, Dart-side shadow.
// ---------------------------------------------------------------------------

class _ScanLogo extends StatefulWidget {
  final String label;
  final bool isScanning;
  final Future<void> Function() onTap;

  const _ScanLogo({
    required this.label,
    required this.isScanning,
    required this.onTap,
  });

  @override
  State<_ScanLogo> createState() => _ScanLogoState();
}

class _ScanLogoState extends State<_ScanLogo> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return GestureDetector(
      onTap: widget.isScanning ? null : () => widget.onTap(),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        scale: _pressed ? 0.94 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isScanning)
              SizedBox(
                width: 140,
                height: 140,
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 16,
                    color: accent,
                  ),
                ),
              )
            else
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 14,
                          sigmaY: 14,
                        ),
                        child: Opacity(
                          opacity: 0.32,
                          child: SvgPicture.asset(
                            'assets/icon/mark_brass.svg',
                            width: 140,
                            height: 140,
                            colorFilter: ColorFilter.mode(
                              accent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icon/mark_brass.svg',
                      width: 140,
                      height: 140,
                      colorFilter: ColorFilter.mode(
                        accent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.label,
              style: AppTypography.chrome.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
