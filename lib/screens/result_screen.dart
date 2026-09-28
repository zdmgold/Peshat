import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  final ScanProvider _provider = ScanProvider();
  late String _targetLanguage;
  late TabController _tabs;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _targetLanguage = widget.initialTargetLanguage;
    _tabs = TabController(length: 2, vsync: this);
    _provider.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPipeline());
  }

  @override
  void dispose() {
    _provider.removeListener(_onStateChanged);
    _provider.dispose();
    _tabs.dispose();
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
      if (mounted) _tabs.animateTo(1);
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
      case AppErrorCode.noTextDetected: return l10n.errorNoTextDetected;
      case AppErrorCode.imageUnreadable: return l10n.errorImageUnreadable;
      case AppErrorCode.modelDownloadFailed: return l10n.errorModelDownloadFailed;
      case AppErrorCode.unsupportedLanguage: return l10n.errorUnsupportedLanguage;
      case AppErrorCode.ocrFailed: return l10n.errorOcrFailed;
      case AppErrorCode.translationFailed: return l10n.errorTranslationFailed;
      case AppErrorCode.timeout: return l10n.errorTimeout;
      case AppErrorCode.unknown: return l10n.errorUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ValueListenableBuilder<ScanState>(
            valueListenable: _provider,
            builder: (context, state, _) {
              final enabled = state is ScanDone;
              return TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: l10n.sourceLabel),
                  Tab(text: l10n.translationLabel),
                ],
                onTap: (i) {
                  if (!enabled) _tabs.index = 0;
                },
              );
            },
          ),
        ),
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
            if (state is ScanError) {
              return _ErrorView(
                message: _errorText(l10n, state.code),
                detail: state.detail,
                onRetry: _runPipeline,
              );
            }
            if (state is ScanDone) {
              return TabBarView(
                controller: _tabs,
                children: [
                  _PanelView(
                    text: state.sourceText,
                    subtitle: languageDisplayName(state.sourceLanguage),
                    onCopy: () => _copy(state.sourceText, l10n),
                    onShareText: () => _shareText(state.sourceText),
                    onExportTxt: () => _export(
                      state.sourceText,
                      'peshat_original_${state.sourceLanguage}',
                      l10n,
                      asPdf: false,
                    ),
                    onExportPdf: () => _export(
                      state.sourceText,
                      'peshat_original_${state.sourceLanguage}',
                      l10n,
                      asPdf: true,
                    ),
                    actionsLabel: l10n.copyAction,
                    exportTxtLabel: l10n.exportTxtAction,
                    exportPdfLabel: l10n.exportPdfAction,
                    shareLabel: l10n.shareAction,
                  ),
                  _TranslationTab(
                    state: state,
                    onCopy: () => _copy(state.translatedText, l10n),
                    onShareText: () => _shareText(state.translatedText),
                    onExportTxt: () => _export(
                      state.translatedText,
                      'peshat_translation_${state.targetLanguage}',
                      l10n,
                      asPdf: false,
                    ),
                    onExportPdf: () => _export(
                      state.translatedText,
                      'peshat_translation_${state.targetLanguage}',
                      l10n,
                      asPdf: true,
                    ),
                    onChangeLanguage: _pickLanguage,
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _copy(String text, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copiedMessage),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _shareText(String text) async {
    await Share.share(text);
  }

  Future<void> _export(
    String text,
    String baseName,
    AppLocalizations l10n, {
    required bool asPdf,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      late final File file;
      if (asPdf) {
        final doc = pw.Document();
        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (ctx) => [
              pw.Paragraph(
                text: text,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
        final path = '${dir.path}/$baseName.pdf';
        file = File(path);
        await file.writeAsBytes(await doc.save());
      } else {
        final path = '${dir.path}/$baseName.txt';
        file = File(path);
        await file.writeAsString(text);
      }
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
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
    return SingleChildScrollView(
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
    );
  }
}

class _PanelView extends StatelessWidget {
  final String text;
  final String subtitle;
  final VoidCallback onCopy;
  final VoidCallback onShareText;
  final VoidCallback onExportTxt;
  final VoidCallback onExportPdf;
  final String actionsLabel;
  final String exportTxtLabel;
  final String exportPdfLabel;
  final String shareLabel;

  const _PanelView({
    required this.text,
    required this.subtitle,
    required this.onCopy,
    required this.onShareText,
    required this.onExportTxt,
    required this.onExportPdf,
    required this.actionsLabel,
    required this.exportTxtLabel,
    required this.exportPdfLabel,
    required this.shareLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.md),
            child: SelectableText(
              text,
              style: AppTypography.sourceChip.copyWith(
                fontSize: 14,
                height: 1.6,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ),
        _ActionBar(
          subtitle: subtitle,
          onCopy: onCopy,
          onShareText: onShareText,
          onExportTxt: onExportTxt,
          onExportPdf: onExportPdf,
          copyLabel: actionsLabel,
          shareLabel: shareLabel,
          exportTxtLabel: exportTxtLabel,
          exportPdfLabel: exportPdfLabel,
        ),
      ],
    );
  }
}

class _TranslationTab extends StatelessWidget {
  final ScanDone state;
  final VoidCallback onCopy;
  final VoidCallback onShareText;
  final VoidCallback onExportTxt;
  final VoidCallback onExportPdf;
  final VoidCallback onChangeLanguage;

  const _TranslationTab({
    required this.state,
    required this.onCopy,
    required this.onShareText,
    required this.onExportTxt,
    required this.onExportPdf,
    required this.onChangeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Spacing.md, Spacing.md, Spacing.md, Spacing.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onChangeLanguage,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md, vertical: Spacing.sm),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.bgSecondaryDark
                    : AppColors.bgSecondaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.borderSubtleDark
                      : AppColors.borderSubtleLight,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.translate,
                      size: 18,
                      color: isDark
                          ? AppColors.accentDark
                          : AppColors.accentLight),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    l10n.translatedTo,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      languageDisplayName(state.targetLanguage),
                      style: AppTypography.chrome.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      size: 20,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                Spacing.md, Spacing.sm, Spacing.md, Spacing.md),
            child: SelectableText(
              state.translatedText,
              style: AppTypography.body.copyWith(
                fontSize: 17,
                height: 1.6,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ),
        _ActionBar(
          subtitle: languageDisplayName(state.targetLanguage),
          onCopy: onCopy,
          onShareText: onShareText,
          onExportTxt: onExportTxt,
          onExportPdf: onExportPdf,
          copyLabel: l10n.copyAction,
          shareLabel: l10n.shareAction,
          exportTxtLabel: l10n.exportTxtAction,
          exportPdfLabel: l10n.exportPdfAction,
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  final String subtitle;
  final VoidCallback onCopy;
  final VoidCallback onShareText;
  final VoidCallback onExportTxt;
  final VoidCallback onExportPdf;
  final String copyLabel;
  final String shareLabel;
  final String exportTxtLabel;
  final String exportPdfLabel;

  const _ActionBar({
    required this.subtitle,
    required this.onCopy,
    required this.onShareText,
    required this.onExportTxt,
    required this.onExportPdf,
    required this.copyLabel,
    required this.shareLabel,
    required this.exportTxtLabel,
    required this.exportPdfLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bgSecondaryDark
            : AppColors.bgSecondaryLight,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.borderSubtleDark
                : AppColors.borderSubtleLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _ActionButton(icon: Icons.copy, label: copyLabel, onTap: onCopy),
          _ActionButton(
              icon: Icons.ios_share, label: shareLabel, onTap: onShareText),
          _ActionButton(
              icon: Icons.description_outlined,
              label: exportTxtLabel,
              onTap: onExportTxt),
          _ActionButton(
              icon: Icons.picture_as_pdf_outlined,
              label: exportPdfLabel,
              onTap: onExportPdf),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 20,
                    color: isDark
                        ? AppColors.accentDark
                        : AppColors.accentLight),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
