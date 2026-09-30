import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/models/app_theme_mode.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/ui_locale_provider.dart';
import '../core/services/iap_service.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';
import '../widgets/ads_removed_badge.dart';
import '../widgets/cupertino_toast.dart';
import 'history_screen.dart';
import 'language_picker_screen.dart';
import 'license_screen.dart';
import 'ui_language_picker_screen.dart';

const _privacyUrl = 'https://peshat.zdmgold.workers.dev/privacy.html';
const _termsUrl = 'https://peshat.zdmgold.workers.dev/terms.html';
const _supportUrl = 'https://peshat.zdmgold.workers.dev/support.html';
const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.zdmgold.peshat';

const _kChevron = PeshatIcon(icon: AppIcons.chevronForward, size: 16);

class SettingsScreen extends StatefulWidget {
  final ThemeProvider theme;
  final PurchaseProvider purchase;
  final SettingsProvider settings;
  final HistoryProvider history;
  final UiLocaleProvider uiLocale;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.purchase,
    required this.settings,
    required this.history,
    required this.uiLocale,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final IapService _iap = IapService();
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() => _version = '${info.version}+${info.buildNumber}');
      }
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        CupertinoToast.show(context, 'Could not open link');
      }
    }
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

  Future<void> _openHistory() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => HistoryScreen(history: widget.history),
      ),
    );
  }

  Future<void> _requestReview() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      }
    } catch (_) {
      // The OS may decline to show the prompt; that is not an error.
    }
  }

  Future<void> _openLicenses() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const LicenseScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: peshatBackButton(context, color: textPrimary),
        middle: Text(
          l10n.settingsTitle,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                children: [
                  // --- Language ---
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.appLanguageLabel.toUpperCase()),
                    children: [
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.globe),
                        title: Text(l10n.uiLanguageLabel),
                        trailing: _TrailingValue(
                          text: widget.uiLocale.value == null
                              ? l10n.sectionSystemLabel
                              : languageDisplayName(
                                  widget.uiLocale.value!.languageCode),
                          color: textTertiary,
                        ),
                        onTap: _pickUiLanguage,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: widget.settings,
                        builder: (_, code, __) => CupertinoListTile(
                          leading: const PeshatIcon(icon: AppIcons.globe),
                          title: Text(l10n.defaultLanguageLabel),
                          trailing: _TrailingValue(
                            text: languageDisplayName(code),
                            color: textTertiary,
                          ),
                          onTap: _pickTargetLanguage,
                        ),
                      ),
                    ],
                  ),

                  // --- Appearance ---
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.themeLabel.toUpperCase()),
                    children: [
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.palette),
                        title: Text(l10n.themeLabel),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Spacing.md,
                          0,
                          Spacing.md,
                          Spacing.md,
                        ),
                        child: ValueListenableBuilder<AppThemeMode>(
                          valueListenable: widget.theme,
                          builder: (_, mode, __) =>
                              CupertinoSlidingSegmentedControl<AppThemeMode>(
                            groupValue: mode,
                            onValueChanged: (v) {
                              if (v != null) widget.theme.setMode(v);
                            },
                            children: {
                              AppThemeMode.light: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  l10n.themeLight,
                                  style: AppTypography.chrome.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              AppThemeMode.system: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  l10n.themeSystem,
                                  style: AppTypography.chrome.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              AppThemeMode.dark: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  l10n.themeDark,
                                  style: AppTypography.chrome.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --- History ---
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.historyLabel.toUpperCase()),
                    children: [
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.history),
                        title: Text(l10n.historyLabel),
                        trailing: _kChevron,
                        onTap: _openHistory,
                      ),
                    ],
                  ),

                  // --- Ads ---
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.purchase,
                    builder: (_, adsRemoved, __) {
                      if (adsRemoved) {
                        return CupertinoListSection.insetGrouped(
                          header: Text(l10n.adStatusLabel.toUpperCase()),
                          children: [
                            CupertinoListTile(
                              leading: const PeshatIcon(icon: AppIcons.verified),
                              title: Text(l10n.adStatusLabel),
                              trailing: const AdsRemovedBadge(),
                            ),
                          ],
                        );
                      }
                      return CupertinoListSection.insetGrouped(
                        header: Text(l10n.adStatusLabel.toUpperCase()),
                        children: [
                          CupertinoListTile(
                            leading: const PeshatIcon(icon: AppIcons.adsClick),
                            title: Text(l10n.removeAdsButton),
                            subtitle: Text(l10n.removeAdsSubtitle),
                            trailing: _SmallOutlinedButton(
                              label: l10n.removeAdsShortLabel,
                              accent: accent,
                              onPressed: _iap.buyRemoveAds,
                            ),
                          ),
                          CupertinoListTile(
                            leading: const PeshatIcon(icon: AppIcons.restore),
                            title: Text(l10n.restorePurchaseButton),
                            onTap: _iap.restore,
                          ),
                        ],
                      );
                    },
                  ),

                  // --- Legal & help ---
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.supportLink.toUpperCase()),
                    children: [
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.privacy),
                        title: Text(l10n.privacyPolicyLink),
                        trailing: _kChevron,
                        onTap: () => _openUrl(_privacyUrl),
                      ),
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.docText),
                        title: Text(l10n.termsLink),
                        trailing: _kChevron,
                        onTap: () => _openUrl(_termsUrl),
                      ),
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.support),
                        title: Text(l10n.supportLink),
                        trailing: _kChevron,
                        onTap: () => _openUrl(_supportUrl),
                      ),
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.code),
                        title: Text(l10n.licensesLabel),
                        trailing: _kChevron,
                        onTap: _openLicenses,
                      ),
                    ],
                  ),

                  // --- About ---
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.aboutLabel.toUpperCase()),
                    children: [
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.verified),
                        title: Text(l10n.rateAppLabel),
                        trailing: _kChevron,
                        onTap: _requestReview,
                      ),
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.share),
                        title: Text(l10n.shareAppLabel),
                        trailing: _kChevron,
                        onTap: () => Share.share(
                          '${l10n.appName} — $_playStoreUrl',
                          subject: l10n.appName,
                        ),
                      ),
                      CupertinoListTile(
                        leading: const PeshatIcon(icon: AppIcons.info),
                        title: Text(l10n.aboutLabel),
                        subtitle: Text('${l10n.versionLabel} $_version'),
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.xl),
                ],
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
// Small outlined button (Remove ads row) — 44dp tap target, 36dp visual pill
// ---------------------------------------------------------------------------

class _SmallOutlinedButton extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback onPressed;

  const _SmallOutlinedButton({
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 44,
      onPressed: onPressed,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent, width: 1),
        ),
        child: Text(
          label,
          style: AppTypography.chrome.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trailing value + chevron (rows that display a value and navigate)
// ---------------------------------------------------------------------------

class _TrailingValue extends StatelessWidget {
  final String text;
  final Color color;

  const _TrailingValue({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: AppTypography.chrome.copyWith(
            fontSize: 15,
            color: color,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        _kChevron,
      ],
    );
  }
}
