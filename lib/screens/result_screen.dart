import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/spacing.dart';
import '../core/providers/scan_provider.dart';
import '../core/models/scan_state.dart';
import '../l10n/app_localizations.dart';
import '../widgets/source_text_chip.dart';
import '../widgets/translation_panel.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  const ResultScreen({super.key, required this.imagePath});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScanProvider _provider = ScanProvider();
  final String _targetLang = 'es';

  @override
  void initState() {
    super.initState();
    _runPipeline();
  }

  Future<void> _runPipeline() async {
    final xFile = XFile(widget.imagePath);
    await _provider.runPipeline(image: xFile, targetLanguage: _targetLang);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultTitle),
        backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _provider,
          builder: (context, state, child) {
            if (state is ScanRecognizing || state is ScanTranslating) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ScanDone) {
              return Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SourceTextChip(languageCode: 'en', confidence: 0.95),
                    const SizedBox(height: Spacing.md),
                    Expanded(
                      child: SingleChildScrollView(
                        child: TranslationPanel(text: state.translatedText),
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionIconButton(
                          icon: Icons.copy,
                          label: l10n.copyAction,
                          onTap: () => Clipboard.setData(ClipboardData(text: state.translatedText)),
                        ),
                        _ActionIconButton(
                          icon: Icons.share,
                          label: l10n.shareAction,
                          onTap: () {},
                        ),
                        _ActionIconButton(
                          icon: Icons.save,
                          label: l10n.saveAction,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.readyToScan));
          },
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionIconButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Column(
            children: [
              Icon(icon, color: isDark ? AppColors.accentDark : AppColors.accentLight),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
