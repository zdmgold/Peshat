import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

// ---------------------------------------------------------------
// Cupertino theme builders
// ---------------------------------------------------------------
//
// CupertinoThemeData exposes only six knobs: brightness, primaryColor,
// primaryContrastingColor, barBackgroundColor, scaffoldBackgroundColor,
// and textTheme. There is no per-widget-family theming.
//
// textTheme is intentionally left at its default. Screens apply their
// own fonts via AppTypography.chrome / .body / .brand at the point of
// use. Setting a textTheme here would require materializing a
// GoogleFonts instance at runtime, which CupertinoThemeData's const
// constructor does not permit.

CupertinoThemeData buildLightCupertinoTheme() {
  return const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.accentLight,
    primaryContrastingColor: Color(0xFFFFFFFF),
    barBackgroundColor: AppColors.bgPrimaryLight,
    scaffoldBackgroundColor: AppColors.bgPrimaryLight,
  );
}

CupertinoThemeData buildDarkCupertinoTheme() {
  return const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accentDark,
    primaryContrastingColor: Color(0xFFFFFFFF),
    barBackgroundColor: AppColors.bgPrimaryDark,
    scaffoldBackgroundColor: AppColors.bgPrimaryDark,
  );
}
