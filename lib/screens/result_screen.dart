import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;
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
import '../widgets/ad_slot.dart';
import '../widgets/segmented_control.dart';
import 'language_picker_screen.dart';

enum _ResultTab { original, translation }

class ResultScreen extends StatefulWidget {
  final String? imagePath;
  final String? inputText;
  final String initialTargetLanguage;
  final HistoryProvider history;

  const ResultScreen({
    super.key,
    this.imagePath,
    this.inputText,
    required this.initialTargetLanguage,
    required this.history,
  }) : assert(imagePath != null || inputText != null,
            'Either imagePath or inputText must be provided');

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScanProvider _provider = ScanProvider();
  late String _targetLanguage;
  _ResultTab _tab = _ResultTab.original;
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
      if (mounted) setState(() => _tab = _ResultTab.translation);
    }
  }

  Future<void> _runPipeline() async {
    if (widget.imagePath != null) {
      await _provider.runImagePipeline(
        image: XFile(widget.imagePath!),
        targetLanguage: _targetLanguage,
      );
    } else {
      await _provider.runTextPipeline(
        text: widget.inputText!,
        targetLanguage: _targetLanguage,
      );
    }
  }

  Future<void> _pickLanguage() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(
          current: _targetLanguage,
        ),
      ),
    );
    if (selected != null && selected != _targetLanguage) {
      setState(() {
        _targetLanguage = selected;
        _saved = false;
        _tab = _ResultTab.original;
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

  String _currentText(ScanDone state) =>
      _tab == _ResultTab.original ? state.sourceText : state.translatedText;

  String _currentBaseName() =>
      _tab == _ResultTab.original ? 'peshat_original' : 'peshat_translation';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return ValueListenableBuilder<ScanState>(
      valueListenable: _provider,
      builder: (context, state, _) {
        final ready = state is ScanDone;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.resultTitle,
              style: AppTypography.chrome.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              if (ready) ...[
                IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 22),
                  tooltip: l10n.copyAction,
                  onPressed: () => _copy(_currentText(state)),
                ),
                IconButton(
                  icon: const Icon(Icons.ios_share, size: 22),
                  tooltip: l10n.shareAction,
                  onPressed: () => _share(_currentText(state)),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, size: 22),
                  tooltip: MaterialLocalizations.of(context)
                      .showMenuTooltip,
                  onSelected: (v) {
                    if (v == 'txt') {
                      _export(_currentText(state), _currentBaseName(),
                          asPdf: false);
                    } else if (v == 'pdf') {
                      _export(_currentText(state), _currentBaseName(),
                          asPdf: true);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'txt',
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined, size: 20),
                          const SizedBox(width: Spacing.md),
                          Text(l10n.exportTxtAction),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_outlined, size: 20),
                          const SizedBox(width: Spacing.md),
                          Text(l10n.exportPdfAction),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(child: _buildContent(context, state, l10n, isDark, accent)),
                const AdSlot(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ScanState state,
    AppLocalizations l10n,
    bool isDark,
    Color accent,
  ) {
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
        detail: kDebugMode ? state.detail : null,
        onRetry: _runPipeline,
      );
    }
    if (state is ScanDone) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.md,
              Spacing.sm,
              Spacing.md,
              Spacing.sm,
            ),
            child: SegmentedControl<_ResultTab>(
              value: _tab,
              onChanged: (v) => setState(() => _tab = v),
              items: [
                SegmentItem(
                  value: _ResultTab.original,
                  label: l10n.sourceLabel,
                ),
                SegmentItem(
                  value: _ResultTab.translation,
                  label: l10n.translationLabel,
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tab.index,
              children: [
                _OriginalTab(
                  sourceText: state.sourceText,
                  isDark: isDark,
                ),
                _TranslationTab(
                  translatedText: state.translatedText,
                  targetLanguage: state.targetLanguage,
                  onPickLanguage: _pickLanguage,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _share(String text) async {
    await Share.share(text);
  }

  Future<void> _export(
    String text,
    String baseName, {
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

// ---------------------------------------------------------------------------
// Original tab
// ---------------------------------------------------------------------------

class _OriginalTab extends StatelessWidget {
  final String sourceText;
  final bool isDark;

  const _OriginalTab({
    required this.sourceText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.md,
        Spacing.md,
        Spacing.md,
      ),
      child: SelectableText(
        sourceText,
        style: AppTypography.sourceChip.copyWith(
          fontSize: 14,
          height: 1.5,
          color: textPrimary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Translation tab
// ---------------------------------------------------------------------------

class _TranslationTab extends StatelessWidget {
  final String translatedText;
  final String targetLanguage;
  final VoidCallback onPickLanguage;
  final bool isDark;

  const _TranslationTab({
    required this.translatedText,
    required this.targetLanguage,
    required this.onPickLanguage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final cardBg =
        isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Material(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPickLanguage,
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.translate, size: 18, color: accent),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      l10n.translatedTo,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        languageDisplayName(targetLanguage),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Icon(Icons.chevron_right,
                        size: 18, color: textTertiary),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: SelectableText(
              translatedText,
              style: AppTypography.body.copyWith(
                fontSize: 17,
                height: 1.6,
                color: textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status + error views
// ---------------------------------------------------------------------------

class _StatusView extends StatelessWidget {
  final String message;
  const _StatusView({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: accent,
                strokeWidth: 2.5,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.chrome.copyWith(
                fontSize: 15,
                color: textSecondary,
              ),
            ),
          ],
        ),
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
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final error = isDark ? AppColors.errorDark : AppColors.errorLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: error),
          const SizedBox(height: Spacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.chrome.copyWith(
              fontSize: 16,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.retryButton),
            ),
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
