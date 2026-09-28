import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../widgets/ads_removed_badge.dart';
import '../widgets/grouped_card.dart';
import '../widgets/segmented_control.dart';
import 'history_screen.dart';
import 'language_picker_screen.dart';
import 'ui_language_picker_screen.dart';

const _privacyUrl = 'https://peshat.zdmgold.workers.dev/privacy.html';
const _termsUrl = 'https://peshat.zdmgold.workers.dev/terms.html';
const _supportUrl = 'https://peshat.zdmgold.workers.dev/support.html';
const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.zdmgold.peshat';

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  Future<void> _pickTargetLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
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

  Future<void> _openHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryScreen(history: widget.history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.md,
          ),
          children: [
            // --- Language ---
            _SectionHeader(label: l10n.appLanguageLabel),
            GroupedCard(
              children: [
                GroupedRow(
                  leading: Icons.language,
                  title: l10n.uiLanguageLabel,
                  trailingText: widget.uiLocale.value == null
                      ? l10n.sectionSystemLabel
                      : languageDisplayName(
                          widget.uiLocale.value!.languageCode),
                  showChevron: true,
                  onTap: _pickUiLanguage,
                ),
                ValueListenableBuilder<String>(
                  valueListenable: widget.settings,
                  builder: (_, code, __) => GroupedRow(
                    leading: Icons.translate,
                    title: l10n.defaultLanguageLabel,
                    trailingText: languageDisplayName(code),
                    showChevron: true,
                    onTap: _pickTargetLanguage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // --- Appearance ---
            _SectionHeader(label: l10n.themeLabel),
            GroupedCard(
              children: [
                GroupedRow(
                  leading: Icons.palette_outlined,
                  title: l10n.themeLabel,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.md,
                    Spacing.sm,
                    Spacing.md,
                    Spacing.md,
                  ),
                  child: ValueListenableBuilder<ThemeMode>(
                    valueListenable: widget.theme,
                    builder: (_, mode, __) => SegmentedControl<ThemeMode>(
                      value: mode,
                      onChanged: widget.theme.setMode,
                      items: [
                        SegmentItem(
                          value: ThemeMode.light,
                          label: l10n.themeLight,
                        ),
                        SegmentItem(
                          value: ThemeMode.system,
                          label: l10n.themeSystem,
                        ),
                        SegmentItem(
                          value: ThemeMode.dark,
                          label: l10n.themeDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // --- History ---
            _SectionHeader(label: l10n.historyLabel),
            GroupedCard(
              children: [
                GroupedRow(
                  leading: Icons.history,
                  title: l10n.historyLabel,
                  onTap: _openHistory,
                  showChevron: true,
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // --- Ads (only when not purchased) ---
            ValueListenableBuilder<bool>(
              valueListenable: widget.purchase,
              builder: (_, adsRemoved, __) {
                if (adsRemoved) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionHeader(label: l10n.adStatusLabel),
                      GroupedCard(
                        children: [
                          GroupedRow(
                            leading: Icons.verified,
                            title: l10n.adStatusLabel,
                            trailingWidget: const AdsRemovedBadge(),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.lg),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionHeader(label: l10n.adStatusLabel),
                    GroupedCard(
                      children: [
                        GroupedRow(
                          leading: Icons.ads_click,
                          title: l10n.removeAdsButton,
                          subtitle: l10n.removeAdsSubtitle,
                          trailingWidget: _SmallOutlinedButton(
                            label: l10n.removeAdsShortLabel,
                            onPressed: _iap.buyRemoveAds,
                          ),
                        ),
                        GroupedRow(
                          leading: Icons.restore,
                          title: l10n.restorePurchaseButton,
                          onTap: _iap.restore,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                  ],
                );
              },
            ),

            // --- Legal & help ---
            _SectionHeader(label: l10n.supportLink),
            GroupedCard(
              children: [
                GroupedRow(
                  leading: Icons.privacy_tip_outlined,
                  title: l10n.privacyPolicyLink,
                  onTap: () => _openUrl(_privacyUrl),
                  showChevron: true,
                ),
                GroupedRow(
                  leading: Icons.description_outlined,
                  title: l10n.termsLink,
                  onTap: () => _openUrl(_termsUrl),
                  showChevron: true,
                ),
                GroupedRow(
                  leading: Icons.help_outline,
                  title: l10n.supportLink,
                  onTap: () => _openUrl(_supportUrl),
                  showChevron: true,
                ),
                GroupedRow(
                  leading: Icons.code,
                  title: l10n.licensesLabel,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appName,
                    applicationVersion: _version,
                  ),
                  showChevron: true,
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // --- About ---
            _SectionHeader(label: l10n.aboutLabel),
            GroupedCard(
              children: [
                GroupedRow(
                  leading: Icons.ios_share,
                  title: l10n.shareAppLabel,
                  onTap: () => Share.share(
                    '${l10n.appName} — $_playStoreUrl',
                    subject: l10n.appName,
                  ),
                  showChevron: true,
                ),
                GroupedRow(
                  leading: Icons.info_outline,
                  title: l10n.aboutLabel,
                  subtitle: '${l10n.versionLabel} $_version',
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.xs,
        Spacing.md,
        Spacing.xs,
        Spacing.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.chrome.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: textTertiary,
        ),
      ),
    );
  }
}

class _SmallOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SmallOutlinedButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          side: BorderSide(color: accent, width: 1),
          foregroundColor: accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.chrome.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
