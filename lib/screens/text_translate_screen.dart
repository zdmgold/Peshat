import 'package:flutter/material.dart';
import '../core/providers/history_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/services/language_names.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';
import '../l10n/app_localizations.dart';
import 'language_picker_screen.dart';
import 'result_screen.dart';

class TextTranslateScreen extends StatefulWidget {
  final SettingsProvider settings;
  final HistoryProvider history;

  const TextTranslateScreen({
    super.key,
    required this.settings,
    required this.history,
  });

  @override
  State<TextTranslateScreen> createState() => _TextTranslateScreenState();
}

class _TextTranslateScreenState extends State<TextTranslateScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _pickTarget() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguagePickerScreen(
          current: widget.settings.value,
          recents: widget.settings.recentTargets,
        ),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
  }

  Future<void> _confirmClear() async {
    if (_controller.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.clearTextConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    if (ok == true) {
      _controller.clear();
      setState(() {});
    }
  }

  Future<void> _translate() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          inputText: text,
          initialTargetLanguage: widget.settings.value,
          history: widget.history,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final charCount = _controller.text.characters.length;
    final hasText = _controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.typeTextButtonLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 22),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: _confirmClear,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    style: AppTypography.body.copyWith(
                      fontSize: 17,
                      height: 1.6,
                      color: textPrimary,
                    ),
                    cursorColor: accent,
                    cursorWidth: 2,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.typeTextLabel,
                      hintStyle: AppTypography.chrome.copyWith(
                        fontSize: 17,
                        color: textTertiary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              _BottomStrip(
                settings: widget.settings,
                onPickTarget: _pickTarget,
                charCount: hasText ? charCount : 0,
                l10n: l10n,
                isDark: isDark,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.sm,
                  Spacing.md,
                  Spacing.md,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: hasText ? _translate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          accent.withValues(alpha: 0.3),
                      disabledForegroundColor:
                          Colors.white.withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.translationLabel,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomStrip extends StatelessWidget {
  final SettingsProvider settings;
  final VoidCallback onPickTarget;
  final int charCount;
  final AppLocalizations l10n;
  final bool isDark;

  const _BottomStrip({
    required this.settings,
    required this.onPickTarget,
    required this.charCount,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPickTarget,
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
                    Icon(Icons.translate, size: 22, color: accent),
                    const SizedBox(width: Spacing.md),
                    Text(
                      l10n.translateToLabel,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 15,
                        color: textSecondary,
                      ),
                    ),
                    const Spacer(),
                    ValueListenableBuilder<String>(
                      valueListenable: settings,
                      builder: (_, code, __) => Text(
                        languageDisplayName(code),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.chrome.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Icon(Icons.chevron_right,
                        size: 20, color: textTertiary),
                  ],
                ),
              ),
            ),
          ),
          if (charCount > 0) ...[
            const SizedBox(height: Spacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$charCount ${l10n.charactersLabel}',
                style: AppTypography.chrome.copyWith(
                  fontSize: 12,
                  color: textTertiary,
                ),
              ),
            ),
          ] else
            const SizedBox(height: Spacing.sm),
        ],
      ),
    );
  }
}
