import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

// ---------------------------------------------------------------
// Light theme
// ---------------------------------------------------------------

ThemeData buildLightTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.accentLight,
    onPrimary: Colors.white,
    primaryContainer: AppColors.bgTertiaryLight,
    onPrimaryContainer: AppColors.textPrimaryLight,
    secondary: AppColors.accentLight,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.bgTertiaryLight,
    onSecondaryContainer: AppColors.textPrimaryLight,
    tertiary: AppColors.accentLight,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.bgTertiaryLight,
    onTertiaryContainer: AppColors.textPrimaryLight,
    error: AppColors.errorLight,
    onError: Colors.white,
    errorContainer: AppColors.bgTertiaryLight,
    onErrorContainer: AppColors.errorLight,
    surface: AppColors.bgPrimaryLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.bgSecondaryLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    outline: AppColors.borderSubtleLight,
    outlineVariant: AppColors.borderSubtleLight,
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: AppColors.bgPrimaryDark,
    onInverseSurface: AppColors.textPrimaryDark,
    inversePrimary: AppColors.accentDark,
    surfaceTint: Colors.transparent,
  );
  return _baseTheme(scheme, isDark: false);
}

// ---------------------------------------------------------------
// Dark theme
// ---------------------------------------------------------------

ThemeData buildDarkTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.accentDark,
    onPrimary: Colors.black,
    primaryContainer: AppColors.bgTertiaryDark,
    onPrimaryContainer: AppColors.textPrimaryDark,
    secondary: AppColors.accentDark,
    onSecondary: Colors.black,
    secondaryContainer: AppColors.bgTertiaryDark,
    onSecondaryContainer: AppColors.textPrimaryDark,
    tertiary: AppColors.accentDark,
    onTertiary: Colors.black,
    tertiaryContainer: AppColors.bgTertiaryDark,
    onTertiaryContainer: AppColors.textPrimaryDark,
    error: AppColors.errorDark,
    onError: Colors.black,
    errorContainer: AppColors.bgTertiaryDark,
    onErrorContainer: AppColors.errorDark,
    surface: AppColors.bgPrimaryDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.bgSecondaryDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.borderSubtleDark,
    outlineVariant: AppColors.borderSubtleDark,
    shadow: Colors.black,
    scrim: Colors.black87,
    inverseSurface: AppColors.bgPrimaryLight,
    onInverseSurface: AppColors.textPrimaryLight,
    inversePrimary: AppColors.accentLight,
    surfaceTint: Colors.transparent,
  );
  return _baseTheme(scheme, isDark: true);
}

// ---------------------------------------------------------------
// Shared theme body
// ---------------------------------------------------------------

ThemeData _baseTheme(ColorScheme scheme, {required bool isDark}) {
  final bg = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;
  final bgSecondary =
      isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight;
  final textPrimary =
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  final textSecondary =
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  final textTertiary =
      isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
  final border =
      isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
  final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

  final base = ThemeData(
    useMaterial3: true,
    brightness: scheme.brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    canvasColor: bg,
    splashFactory: InkSparkle.splashFactory,
  );

  return base.copyWith(
    // AppBar — flat, no M3 tint, token text
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.chrome.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary, size: 22),
      actionsIconTheme: IconThemeData(color: textPrimary, size: 22),
    ),

    // Elevated button — brass, white text, 12 radius, 48 min height
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: border,
        disabledForegroundColor: textTertiary,
        elevation: 0,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.chrome.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined — brass border, brass text
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent, width: 1),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.chrome.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text button — brass text, no background
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.chrome.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // FAB — brass
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ListTile — no default M3 tint on icons, token colors
    listTileTheme: ListTileThemeData(
      iconColor: textSecondary,
      textColor: textPrimary,
      selectedColor: accent,
      selectedTileColor: bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Divider — subtle
    dividerTheme: DividerThemeData(
      color: border,
      thickness: 0.5,
      space: 0.5,
    ),

    // Cards — subtle border, 16 radius, no shadow
    cardTheme: CardThemeData(
      color: bgSecondary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    // Inputs — filled tertiary, brass border on focus
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.bgTertiaryDark : AppColors.bgTertiaryLight,
      hintStyle: AppTypography.chrome.copyWith(color: textTertiary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
    ),

    // Dialogs — surface token, 16 radius
    dialogTheme: DialogThemeData(
      backgroundColor: bgSecondary,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: AppTypography.chrome.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      contentTextStyle: AppTypography.chrome.copyWith(
        fontSize: 15,
        color: textSecondary,
      ),
    ),

    // Bottom sheets — 20 top radius
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bgSecondary,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // SnackBar — inverse surface, subtle
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: AppTypography.chrome.copyWith(
        color: scheme.onInverseSurface,
        fontSize: 14,
      ),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Progress indicators — brass
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
      circularTrackColor: Colors.transparent,
    ),

    // Icon defaults
    iconTheme: IconThemeData(color: textSecondary, size: 22),
    primaryIconTheme: IconThemeData(color: textPrimary, size: 22),

    // TabBar — brass underline
    tabBarTheme: TabBarThemeData(
      labelColor: accent,
      unselectedLabelColor: textSecondary,
      indicatorColor: accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelStyle: AppTypography.chrome.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.chrome.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Checkbox / Radio / Switch — brass
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return Colors.transparent;
      }),
      side: BorderSide(color: border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return textSecondary;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return border;
      }),
    ),

    // Segmented button — kill the M3 teal by setting secondaryContainer
    // (already done via the ColorScheme above; nothing to add here)

    // Chip — brass outline
    chipTheme: ChipThemeData(
      backgroundColor: bgSecondary,
      side: BorderSide(color: border, width: 0.5),
      labelStyle: AppTypography.chrome.copyWith(
        color: textPrimary,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // Text selection — brass
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: accent,
      selectionColor: accent.withValues(alpha: 0.3),
      selectionHandleColor: accent,
    ),

  );
}
