import 'package:flutter/cupertino.dart';
import '../core/utils/app_icons.dart';
import '../widgets/peshat_icon.dart';
import '../widgets/action_card.dart';
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
            // Full-bleed text field — the page is the surface.
            Expanded(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.md,
                ),
                decoration: null,
                onChanged: (_) => setState(() {}),
              ),
            ),

            // Character count — right-aligned, above the language row.
            if (hasText)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  0,
                  Spacing.md,
                  Spacing.sm,
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

            // Language selector — filled card.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: ValueListenableBuilder<String>(
                valueListenable: widget.settings,
                builder: (_, code, __) => ActionCard(
                  icon: AppIcons.globe,
                  label: l10n.translateToLabel,
                  value: languageDisplayName(code),
                  showChevron: true,
                  onTap: _pickTarget,
                ),
              ),
            ),

            // Primary translate button.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                12,
                Spacing.md,
                Spacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: hasText ? _translate : null,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.translationLabel,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFFFFF),
                      ),
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
