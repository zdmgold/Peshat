import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../core/models/app_error_code.dart';
import '../core/models/scan_result.dart';
import '../core/models/scan_state.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/scan_provider.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import 'language_picker_screen.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final String initialTargetLanguage;
  final HistoryProvider history;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.initialTargetLanguage,
    required this.history,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScanProvider _provider = ScanProvider();
  late String _targetLanguage;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _targetLanguage = widget.initialTargetLanguage;
    _provider.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPipeline());
  }

  @override
  void dispose() {
    _provider.removeListener(_onStateChanged);
    _provider.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final s = _provider.value;
    if (s is ScanDone && !_saved) {
      _saved = true;
      widget.history.add(ScanResult(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sourceText: s.sourceText,
        translatedText: s.translatedText,
        sourceLang: s.sourceLanguage,
        targetLang: s.targetLanguage,
        timestamp: DateTime.now(),
        confidence: 1.0,
      ));
    }
  }

  Future<void> _runPipeline() async {
    await _provider.runPipeline(
      image: XFile(widget.imagePath),
      targetLanguage: _targetLanguage,
    );
  }

  Future<void> _pickLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(current: _targetLanguage),
      ),
    );
    if (selected != null && selected != _targetLanguage) {
      setState(() {
        _targetLanguage = selected;
        _saved = false;
      });
      _runPipeline();
    }
  }

  String _errorText(AppLocalizations l10n, AppErrorCode code) {
    switch (code) {
      case AppErrorCode.noTextDetected:
        return l10n.errorNoTextDetected;
      case AppErrorCode.imageUnreadable:
        return l10n.errorImageUnreadable;
      case AppErrorCode.modelDownloadFailed:
        return l10n.errorModelDownloadFailed;
      case AppErrorCode.unsupportedLanguage:
        return l10n.errorUnsupportedLanguage;
      case AppErrorCode.ocrFailed:
        return l10n.errorOcrFailed;
      case AppErrorCode.translationFailed:
        return l10n.errorTranslationFailed;
      case AppErrorCode.timeout:
        return l10n.errorTimeout;
      case AppErrorCode.unknown:
        return l10n.errorUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: l10n.changeLanguageButton,
            onPressed: _pickLanguage,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ScanState>(
          valueListenable: _provider,
          builder: (context, state, _) {
            if (state is ScanRecognizing) {
              return _StatusView(message: l10n.statusRecognizing);
            }
            if (state is ScanPreparingModel) {
              return _StatusView(
                message:
                    '${l10n.statusPreparingModel} ${languageDisplayName(state.targetLanguage)}',
              );
            }
            if (state is ScanTranslating) {
              return _StatusView(message: l10n.statusTranslating);
            }
            if (state is ScanDone) {
              return _DoneView(
                state: state,
                onCopySource: () => _copy(state.sourceText),
                onCopyTranslation: () => _copy(state.translatedText),
                onShare: () => _share(state, l10n),
              );
            }
            if (state is ScanError) {
              return _ErrorView(
                message: _errorText(l10n, state.code),
                detail: state.detail,
                onRetry: _runPipeline,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copyAction),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _share(ScanDone state, AppLocalizations l10n) {
    Share.share(
      '${state.sourceText}\n\n— ${l10n.translationLabel} —\n\n${state.translatedText}',
    );
  }
}

class _StatusView extends StatelessWidget {
  final String message;
  const _StatusView({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: isDark ? AppColors.accentDark : AppColors.accentLight,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            message,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final String? detail;
  final Future<void> Function() onRetry;
  const _ErrorView({
    required this.message,
    required this.onRetry,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56,
                color: isDark ? AppColors.errorDark : AppColors.errorLight),
            const SizedBox(height: Spacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retryButton),
            ),
            if (detail != null) ...[
              const SizedBox(height: Spacing.xl),
              const Divider(),
              const SizedBox(height: Spacing.md),
              SelectableText(
                detail!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  final ScanDone state;
  final VoidCallback onCopySource;
  final VoidCallback onCopyTranslation;
  final VoidCallback onShare;
  const _DoneView({
    required this.state,
    required this.onCopySource,
    required this.onCopyTranslation,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Panel(
            label: l10n.sourceLabel,
            subtitle: languageDisplayName(state.sourceLanguage),
            text: state.sourceText,
            onCopy: onCopySource,
            isDark: isDark,
            mono: true,
          ),
          const SizedBox(height: Spacing.md),
          _Panel(
            label: l10n.translationLabel,
            subtitle: languageDisplayName(state.targetLanguage),
            text: state.translatedText,
            onCopy: onCopyTranslation,
            isDark: isDark,
            mono: false,
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share_outlined, size: 18),
                label: Text(l10n.shareAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String label;
  final String subtitle;
  final String text;
  final VoidCallback onCopy;
  final bool isDark;
  final bool mono;
  const _Panel({
    required this.label,
    required this.subtitle,
    required this.text,
    required this.onCopy,
    required this.isDark,
    required this.mono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bgSecondaryDark
            : AppColors.bgSecondaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.borderSubtleDark
              : AppColors.borderSubtleLight,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.chrome.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                subtitle,
                style: AppTypography.sourceChip.copyWith(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                onPressed: onCopy,
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          SelectableText(
            text,
            style: (mono ? AppTypography.sourceChip : AppTypography.body)
                .copyWith(
              fontSize: mono ? 14 : 17,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
