import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildLightTheme() => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.bgPrimaryLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.accentLight, 
    error: AppColors.errorLight
  ),
);

ThemeData buildDarkTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bgPrimaryDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accentDark, 
    error: AppColors.errorDark
  ),
);
