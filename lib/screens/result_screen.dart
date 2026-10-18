import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../widgets/auto_direction_text.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
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
import '../core/services/pdf_fonts.dart';
import '../core/services/pdf_raster.dart';
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

  /// False when reopening an entry from History, so it isn't saved again.
  final bool saveToHistory;

  /// Lets tests supply a provider with fake services.
  final ScanProvider? provider;

  const ResultScreen({
    super.key,
    this.imagePath,
    this.inputText,
    required this.initialTargetLanguage,
    required this.history,
    this.saveToHistory = true,
    this.provider,
  }) : assert(imagePath != null || inputText != null,
            'Either imagePath or inputText must be provided');

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final ScanProvider _provider = widget.provider ?? ScanProvider();
  late String _targetLanguage;
  _ResultTab _tab = _ResultTab.original;
  late bool _saved = !widget.saveToHistory;

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
    if (s is! ScanDone) return;
    // Always land on the translation, including when reopened from History.
    if (mounted) setState(() => _tab = _ResultTab.translation);
    if (_saved) return;
    _saved = true;
    if (s.sameLanguage) return;
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
      case AppErrorCode.offlinePackNeeded:
        return l10n.errorOfflinePackNeeded;
      case AppErrorCode.packTooSlow:
        return l10n.errorPackTooSlow;
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      layoutBuilder: (current, previous) => Stack(
                        fit: StackFit.expand,
                        children: [...previous, if (current != null) current],
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(state.runtimeType),
                        child: _buildContent(context, state, l10n, isDark),
                      ),
                    ),
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
            '${l10n.statusPreparingModel} ${languageLabel(state.targetLanguage)}',
      );
    }
    if (state is ScanReceivingPack) {
      return _PackView(
        title: l10n.packReceivingTitle,
        languageName: languageLabel(state.current),
        received: false,
        cancelLabel: l10n.cancelButtonLabel,
        onCancel: () {
          _provider.cancel();
          Navigator.of(context).maybePop();
        },
      );
    }
    if (state is ScanPackReceived) {
      return _PackView(
        title: l10n.packReceivedTitle,
        received: true,
      );
    }
    if (state is ScanTranslating) {
      return _StatusView(message: l10n.statusTranslating);
    }
    if (state is ScanError) {
      return _ErrorView(
        message: _errorText(l10n, state.code),
        hint: state.code == AppErrorCode.noTextDetected
            ? l10n.errorNoTextHint
            : null,
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
              thumbColor: (isDark ? AppColors.accentDark : AppColors.accentLight)
                  .withValues(alpha: 0.28),
              backgroundColor: isDark
                  ? AppColors.bgTertiaryDark
                  : AppColors.bgTertiaryLight,
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
                  sourceLanguage: state.sourceLanguage,
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
    final l10n = AppLocalizations.of(context)!;
    try {
      final dir = await getTemporaryDirectory();
      late final File file;
      if (asPdf) {
        final scripts = PdfFonts.scriptsIn(text);
        if (await PdfFonts.needsDownload(scripts) && mounted) {
          CupertinoToast.show(context, l10n.pdfFontDownloading);
        }
        final rtl = PdfFonts.isMostlyRtl(text);
        final doc = pw.Document();
        if (PdfFonts.needsRaster(scripts)) {
          final pages = await PdfRaster.pages(text, scripts, rtl: rtl);
          for (final bytes in pages) {
            final image = pw.MemoryImage(bytes);
            doc.addPage(
              pw.Page(
                pageFormat: PdfPageFormat.a4,
                margin: pw.EdgeInsets.zero,
                build: (ctx) => pw.Image(image, fit: pw.BoxFit.fill),
              ),
            );
          }
        } else {
          final theme = await PdfFonts.themeFor(scripts);
          doc.addPage(
            pw.MultiPage(
              theme: theme,
              pageFormat: PdfPageFormat.a4,
              textDirection:
                  rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              build: (ctx) => [
                pw.Paragraph(
                  text: text,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }
        final path = '${dir.path}/$baseName.pdf';
        file = File(path);
        await file.writeAsBytes(await doc.save());
      } else {
        final path = '${dir.path}/$baseName.txt';
        file = File(path);
        await file.writeAsString(text);
      }
      await Share.shareXFiles([XFile(file.path)]);
    } on PdfFontDownloadException {
      if (mounted) {
        CupertinoToast.show(context, l10n.pdfFontDownloadFailed);
      }
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
        child: AutoDirectionText(
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
  final String sourceLanguage;
  final String targetLanguage;
  final VoidCallback onPickLanguage;
  final bool isDark;

  const _TranslationTab({
    required this.translatedText,
    required this.sourceLanguage,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Semantics(
            button: true,
            label: '${l10n.translatedFrom} ${languageNativeName(sourceLanguage)}, '
                '${l10n.translatedTo} ${languageNativeName(targetLanguage)}',
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      languageNativeName(sourceLanguage),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    child: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? CupertinoIcons.arrow_left
                          : CupertinoIcons.arrow_right,
                      size: 14,
                      color: textSecondary,
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onPickLanguage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                languageNativeName(targetLanguage),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.chrome.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            Icon(
                              CupertinoIcons.chevron_down,
                              size: 12,
                              color: textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
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

/// Shown while a language pack is arriving: a bar that keeps moving (Google
/// gives no progress figure, so it never claims a percentage), then fills and
/// shows a tick once the pack is received.
class _PackView extends StatefulWidget {
  final String title;
  final String? languageName;
  final bool received;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  const _PackView({
    required this.title,
    required this.received,
    this.languageName,
    this.cancelLabel,
    this.onCancel,
  });

  @override
  State<_PackView> createState() => _PackViewState();
}

class _PackViewState extends State<_PackView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final track =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;
    const barWidth = 220.0;
    const barHeight = 6.0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.received)
              PeshatIcon(icon: AppIcons.check, size: 36, color: accent)
            else
              const SizedBox(height: 36),
            const SizedBox(height: Spacing.md),
            Semantics(
              liveRegion: true,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTypography.chrome.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            if (widget.languageName != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.languageName!,
                textAlign: TextAlign.center,
                style: AppTypography.chrome.copyWith(
                  fontSize: 15,
                  color: textSecondary,
                ),
              ),
            ],
            const SizedBox(height: Spacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: SizedBox(
                width: barWidth,
                height: barHeight,
                child: ColoredBox(
                  color: track,
                  child: widget.received
                      ? ColoredBox(color: accent)
                      : AnimatedBuilder(
                          animation: _c,
                          builder: (_, __) {
                            const seg = barWidth * 0.4;
                            final left =
                                (barWidth + seg) * _c.value - seg;
                            return Stack(
                              children: [
                                Positioned(
                                  left: left,
                                  width: seg,
                                  top: 0,
                                  bottom: 0,
                                  child: ColoredBox(color: accent),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ),
            if (!widget.received && widget.onCancel != null) ...[
              const SizedBox(height: Spacing.lg),
              CupertinoButton(
                onPressed: widget.onCancel,
                child: Text(
                  widget.cancelLabel ?? '',
                  style: AppTypography.chrome.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

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
  final String? hint;
  final String? detail;
  final Future<void> Function() onRetry;
  const _ErrorView({
    required this.message,
    required this.onRetry,
    this.hint,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
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
          if (hint != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: AppTypography.chrome.copyWith(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
          ],
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
