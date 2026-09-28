import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_typography.dart';

class SegmentItem<T> {
  final T value;
  final String label;
  const SegmentItem({required this.value, required this.label});
}

/// iOS-style segmented control. Height 32dp, outer track uses bgTertiary,
/// selected segment is filled with bgPrimary and outlined in accent at
/// 30% opacity. Animates the selected segment over 200ms.
///
/// Respects Reduce Motion: the transition collapses to 0ms when
/// MediaQuery.disableAnimationsOf(context) is true.
class SegmentedControl<T> extends StatelessWidget {
  final List<SegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  const SegmentedControl({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 200);

    final track =
        isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight;
    final selectedBg =
        isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: items.map((item) {
          final selected = item.value == value;
          return Expanded(
            child: Semantics(
              label: item.label,
              selected: selected,
              button: true,
              child: GestureDetector(
                onTap: () {
                  if (!selected) onChanged(item.value);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: selected ? selectedBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: selected
                        ? Border.all(
                            color: accent.withValues(alpha: 0.3),
                            width: 0.5,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chrome.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? accent : textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
