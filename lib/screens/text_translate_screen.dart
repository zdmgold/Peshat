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
    final canTranslate = _controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.typeTextButtonLabel),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.md,
                  Spacing.md,
                  Spacing.sm,
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
                    height: 1.5,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.typeTextLabel,
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.all(Spacing.md),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: _pickTarget,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
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
                    Icon(
                      Icons.translate,
                      size: 18,
                      color: isDark
                          ? AppColors.accentDark
                          : AppColors.accentLight,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      l10n.translateToLabel,
                      style: AppTypography.chrome.copyWith(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: widget.settings,
                        builder: (_, code, __) => Text(
                          languageDisplayName(code),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: canTranslate ? _translate : null,
                  icon: const Icon(Icons.arrow_forward, size: 20),
                  label: Text(l10n.translationLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
