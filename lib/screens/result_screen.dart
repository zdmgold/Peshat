import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import '../widgets/action_card.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:flutter/foundation.dart' show kDebugMode;
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
import '../core/services/interstitial_service.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ad_slot.dart';
import '../widgets/cupertino_toast.dart';
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
      InterstitialService.instance.onTranslationCompleted();
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
      CupertinoPageRoute(
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

  Future<void> _showOverflowSheet(ScanDone state) async {
    final l10n = AppLocalizations.of(context)!;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _export(_currentText(state), _currentBaseName(), asPdf: false);
            },
            child: Text(l10n.exportTxtAction),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _export(_currentText(state), _currentBaseName(), asPdf: true);
            },
            child: Text(l10n.exportPdfAction),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancelButtonLabel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return ValueListenableBuilder<ScanState>(
      valueListenable: _provider,
      builder: (context, state, _) {
        final done = state is ScanDone ? state : null;
        return PopScope(
          canPop: done == null,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await InterstitialService.instance.maybeShowOnBack();
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: peshatBackButton(context, color: textPrimary),
              middle: Text(
                l10n.resultTitle,
                style: AppTypography.chrome.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              trailing: done != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 44,
                          onPressed: () => _copy(_currentText(done)),
                          child: Semantics(
                            label: l10n.copyAction,
                            button: true,
                            child: const PeshatIcon(icon: AppIcons.copy,
                                size: 22),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 44,
                          onPressed: () => _share(_currentText(done)),
                          child: Semantics(
                            label: l10n.shareAction,
                            button: true,
                            child: const PeshatIcon(icon: AppIcons.share, size: 22),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 44,
                          onPressed: () => _showOverflowSheet(done),
                          child: Semantics(
                            label: l10n.showMenuTooltip,
                            button: true,
                            child: const PeshatIcon(icon: AppIcons.more, size: 22),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: _buildContent(context, state, l10n, isDark),
                  ),
                  const AdSlot(),
                ],
              ),
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
  ) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

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
            child: CupertinoSlidingSegmentedControl<_ResultTab>(
              groupValue: _tab,
              onValueChanged: (v) {
                if (v != null) setState(() => _tab = v);
              },
              children: {
                _ResultTab.original: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.sourceLabel,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
                _ResultTab.translation: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.translationLabel,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              },
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
    InterstitialService.instance.onCopy();
    Clipboard.setData(ClipboardData(text: text));
    CupertinoToast.show(context, AppLocalizations.of(context)!.copiedMessage);
  }

  Future<void> _share(String text) async {
    InterstitialService.instance.onShare();
    await Share.share(text);
  }

  Future<void> _export(
    String text,
    String baseName, {
    required bool asPdf,
  }) async {
    InterstitialService.instance.onExport();
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
        CupertinoToast.show(context, e.toString());
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
      padding: const EdgeInsets.all(Spacing.md),
      child: SelectionArea(
        child: Text(
          sourceText,
          style: AppTypography.sourceChip.copyWith(
            fontSize: 14,
            height: 1.5,
            color: textPrimary,
          ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: ActionCard(
            icon: AppIcons.globe,
            label: l10n.translatedTo,
            value: languageDisplayName(targetLanguage),
            showChevron: true,
            onTap: onPickLanguage,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: SelectionArea(
              child: Text(
                translatedText,
                style: AppTypography.body.copyWith(
                  fontSize: 17,
                  height: 1.6,
                  color: textPrimary,
                ),
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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(radius: 12, color: accent),
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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final error = isDark ? AppColors.errorDark : AppColors.errorLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PeshatIcon(icon: AppIcons.error, size: 48, color: error),
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
            width: 220,
            height: 56,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onRetry,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent, width: 1),
                ),
                child: Text(
                  l10n.retryButton,
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: Spacing.xl),
            Container(height: 0.5, color: error.withValues(alpha: 0.3)),
            const SizedBox(height: Spacing.md),
            SelectionArea(
              child: Text(
                detail!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Color(0xFFFF5252),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
