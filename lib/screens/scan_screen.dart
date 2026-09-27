import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../core/providers/subscription_provider.dart';
import '../l10n/app_localizations.dart';
import '../platform/document_scanner_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  final SubscriptionProvider subProvider;
  const ScanScreen({super.key, required this.subProvider});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final DocumentScannerService _scanner = DocumentScannerService();
  bool _isScanning = false;

  Future<void> _handleScan() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    try {
      final paths = await _scanner.scan();
      if (mounted && paths.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(imagePath: paths.first)),
        );
      }
    } catch (e) {
      // Silently handle cancellation or errors
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.subProvider,
      builder: (context, isPro, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Semantics(
                  label: l10n.semanticsAppIcon,
                  child: Icon(
                    Icons.document_scanner,
                    size: 80,
                    color: isDark ? AppColors.accentDark : AppColors.accentLight,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  l10n.appName,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                Semantics(
                  label: l10n.semanticsScanButton,
                  child: SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _handleScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.accentDark : AppColors.accentLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isScanning
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                const Spacer(),
                if (!isPro) const BannerAdWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
