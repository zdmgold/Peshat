import 'package:flutter/material.dart';
import '../core/utils/spacing.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/purchase_provider.dart';
import '../core/services/iap_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ads_removed_badge.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final PurchaseProvider purchaseProvider;

  const SettingsScreen({
    super.key,
    required this.themeProvider,
    required this.purchaseProvider,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final IapService _iapService = IapService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.adStatusLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: Spacing.sm),
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.purchaseProvider,
                    builder: (context, adsRemoved, child) =>
                        adsRemoved ? const AdsRemovedBadge() : Text(l10n.adsShownStatus),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              Text(l10n.themeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: Spacing.sm),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.themeProvider,
                builder: (context, currentMode, child) {
                  return SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
                      ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
                      ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      widget.themeProvider.setMode(newSelection.first);
                    },
                  );
                },
              ),
              const SizedBox(height: Spacing.lg),
              ValueListenableBuilder<bool>(
                valueListenable: widget.purchaseProvider,
                builder: (context, adsRemoved, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!adsRemoved) ...[
                        const SizedBox(height: Spacing.sm),
                        Semantics(
                          label: l10n.semanticsRemoveAds,
                          child: ElevatedButton(
                            onPressed: _iapService.buyRemoveAds,
                            child: Text(l10n.removeAdsButton),
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.sm),
                      Semantics(
                        label: l10n.restorePurchaseButton,
                        child: TextButton(
                          onPressed: _iapService.restore,
                          child: Text(l10n.restorePurchaseButton),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Semantics(
                      label: l10n.privacyPolicyLink,
                      child: TextButton(onPressed: () {}, child: Text(l10n.privacyPolicyLink)),
                    ),
                    Semantics(
                      label: l10n.supportLink,
                      child: TextButton(onPressed: () {}, child: Text(l10n.supportLink)),
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
