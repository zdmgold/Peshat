import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
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
      CupertinoPageRoute(
        builder: (_) => LanguagePickerScreen(
          current: widget.settings.value,
          recents: widget.settings.recentTargets,
        ),
      ),
    );
    if (selected != null) widget.settings.setTarget(selected);
  }

  Future<void> _clear() async {
    if (_controller.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Text(l10n.clearTextConfirm),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButtonLabel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.okButtonLabel),
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
      CupertinoPageRoute(
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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final inputFill =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;
    final charCount = _controller.text.characters.length;
    final hasText = _controller.text.trim().isNotEmpty;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: peshatBackButton(context, color: textPrimary),
        middle: Text(
          l10n.typeTextButtonLabel,
          style: AppTypography.chrome.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 44,
          onPressed: _clear,
          child: Semantics(
            label: l10n.closeButtonTooltip,
            button: true,
            child: const PeshatIcon(icon: AppIcons.close, size: 22),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: inputFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(Spacing.md),
                  child: CupertinoTextField(
                    controller: _controller,
                    focusNode: _focus,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    placeholder: l10n.typeTextLabel,
                    placeholderStyle: AppTypography.chrome.copyWith(
                      fontSize: 16,
                      color: textTertiary,
                    ),
                    style: AppTypography.body.copyWith(
                      fontSize: 17,
                      height: 1.6,
                      color: textPrimary,
                    ),
                    cursorColor: accent,
                    cursorWidth: 2,
                    padding: EdgeInsets.zero,
                    decoration: null,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: _TargetLanguageRow(
                label: l10n.translateToLabel,
                settings: widget.settings,
                isDark: isDark,
                onTap: _pickTarget,
              ),
            ),
            if (hasText)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.sm,
                  Spacing.md,
                  0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$charCount ${l10n.charactersLabel}',
                    style: AppTypography.chrome.copyWith(
                      fontSize: 12,
                      color: textTertiary,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  onPressed: hasText ? _translate : null,
                  child: Text(
                    l10n.translationLabel,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Target language row — grouped-card styled, iOS press feedback
// ---------------------------------------------------------------------------

class _TargetLanguageRow extends StatefulWidget {
  final String label;
  final SettingsProvider settings;
  final bool isDark;
  final VoidCallback onTap;

  const _TargetLanguageRow({
    required this.label,
    required this.settings,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_TargetLanguageRow> createState() => _TargetLanguageRowState();
}

class _TargetLanguageRowState extends State<_TargetLanguageRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = widget.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final textTertiary = widget.isDark
        ? AppColors.textTertiaryDark
        : AppColors.textTertiaryLight;
    final border = widget.isDark
        ? AppColors.borderSubtleDark
        : AppColors.borderSubtleLight;
    final accent =
        widget.isDark ? AppColors.accentDark : AppColors.accentLight;
    final cardBg = widget.isDark
        ? AppColors.bgSecondaryDark
        : AppColors.bgSecondaryLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1.0,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Row(
            children: [
              PeshatIcon(icon: AppIcons.globe, size: 22, color: accent),
              const SizedBox(width: Spacing.md),
              Text(
                widget.label,
                style: AppTypography.chrome.copyWith(
                  fontSize: 15,
                  color: textSecondary,
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<String>(
                valueListenable: widget.settings,
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
              PeshatIcon(icon: AppIcons.chevronForward,
                  size: 20, color: textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
