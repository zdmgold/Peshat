import 'package:flutter/cupertino.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';

/// iOS-style toast. Slides in from the top, auto-dismisses after 2 seconds.
///
/// Cupertino has no equivalent of Material's SnackBar. This is the smallest
/// usable substitute: a floating pill inserted via [OverlayEntry], positioned
/// below the status bar, with no interaction required to dismiss it.
class CupertinoToast {
  static OverlayEntry? _current;

  static void show(BuildContext context, String message) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
    final fg =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final border =
        isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + Spacing.md,
        left: Spacing.md,
        right: Spacing.md,
        child: IgnorePointer(
          child: _ToastBody(
            message: message,
            bg: bg,
            fg: fg,
            border: border,
          ),
        ),
      ),
    );

    _current = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      if (_current == entry) {
        entry.remove();
        _current = null;
      }
    });
  }
}

class _ToastBody extends StatelessWidget {
  final String message;
  final Color bg;
  final Color fg;
  final Color border;

  const _ToastBody({
    required this.message,
    required this.bg,
    required this.fg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTypography.chrome.copyWith(
          fontSize: 14,
          color: fg,
        ),
      ),
    );
  }
}
