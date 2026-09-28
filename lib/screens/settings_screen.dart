import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/ui_locale_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/services/iap_service.dart';
import '../core/services/language_names.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ads_removed_badge.dart';
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

  Future<void> _pickLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(current: widget.settings.value),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          children: [
            // Default target language
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(l10n.defaultLanguageLabel),
              subtitle: ValueListenableBuilder<String>(
                valueListenable: widget.settings,
                builder: (_, code, __) => Text(languageDisplayName(code)),
              ),
              onTap: _pickLanguage,
            ),

            // UI language
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.uiLanguageLabel),
              subtitle: ValueListenableBuilder<Locale?>(
                valueListenable: widget.uiLocale,
                builder: (_, loc, __) => Text(
                  loc == null
                      ? 'Follow system'
                      : languageDisplayName(loc.languageCode),
                ),
              ),
              onTap: _pickUiLanguage,
            ),

            // Theme
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Spacing.md, Spacing.md, Spacing.md, Spacing.sm),
              child: Text(l10n.themeLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: widget.theme,
              builder: (_, mode, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(l10n.themeLight)),
                    ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(l10n.themeSystem)),
                    ButtonSegment(
                        value: ThemeMode.dark, label: Text(l10n.themeDark)),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) => widget.theme.setMode(s.first),
                ),
              ),
            ),

            const Divider(height: Spacing.xl),

            // History
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(l10n.historyLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(history: widget.history),
                ),
              ),
            ),

            const Divider(height: Spacing.xl),

            // Ad status + purchase
            ValueListenableBuilder<bool>(
              valueListenable: widget.purchase,
              builder: (_, adsRemoved, __) => Column(
                children: [
                  ListTile(
                    leading: Icon(adsRemoved
                        ? Icons.verified
                        : Icons.ads_click),
                    title: Text(l10n.adStatusLabel),
                    trailing: adsRemoved
                        ? const AdsRemovedBadge()
                        : Text(l10n.adsShownStatus),
                  ),
                  if (!adsRemoved)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _iap.buyRemoveAds,
                          child: Text(l10n.removeAdsButton),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md, vertical: Spacing.sm),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _iap.restore,
                        child: Text(l10n.restorePurchaseButton),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: Spacing.xl),

            // Legal + support
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.privacyPolicyLink),
              onTap: () => _openUrl(_privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.termsLink),
              onTap: () => _openUrl(_termsUrl),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.supportLink),
              onTap: () => _openUrl(_supportUrl),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.licensesLabel),
              onTap: () => showLicensePage(
                context: context,
                applicationName: l10n.appName,
                applicationVersion: _version,
              ),
            ),

            const Divider(height: Spacing.xl),

            // Share + about
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n.shareAppLabel),
              onTap: () => Share.share(
                '${l10n.appName} — $_playStoreUrl',
                subject: l10n.appName,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutLabel),
              subtitle: Text('${l10n.versionLabel} $_version'),
            ),
          ],
        ),
      ),
    );
  }
}
