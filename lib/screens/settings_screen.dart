import 'package:flutter/material.dart';
import '../core/utils/spacing.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/subscription_provider.dart';
import '../core/services/iap_service.dart';
import '../widgets/pro_badge.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final SubscriptionProvider subProvider;
  
  const SettingsScreen({
    super.key, 
    required this.themeProvider, 
    required this.subProvider,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final IapService _iapService = IapService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Pro Status:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: Spacing.sm),
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.subProvider,
                    builder: (context, isPro, child) => isPro ? const ProBadge() : const Text('Free'),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: Spacing.sm),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.themeProvider,
                builder: (context, currentMode, child) {
                  return SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                      ButtonSegment(value: ThemeMode.system, label: Text('System')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
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
                valueListenable: widget.subProvider,
                builder: (context, isPro, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isPro) ...[
                        const SizedBox(height: Spacing.sm),
                        Semantics(
                          label: 'Upgrade to Pro',
                          child: ElevatedButton(
                            onPressed: _iapService.buyPro,
                            child: const Text('Upgrade to Pro (Remove Ads)'),
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.sm),
                      Semantics(
                        label: 'Restore Purchase',
                        child: TextButton(
                          onPressed: _iapService.restore,
                          child: const Text('Restore Purchase'),
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
                    Semantics(label: 'Privacy Policy', child: TextButton(onPressed: () {}, child: const Text('Privacy Policy'))),
                    Semantics(label: 'Support', child: TextButton(onPressed: () {}, child: const Text('Support'))),
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
