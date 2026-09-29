import 'package:hugeicons/hugeicons.dart';

/// Semantic icon aliases for Peshat.
///
/// Every icon the app renders is aliased here against a HugeIcons Stroke
/// Rounded symbol. Screens reference [AppIcons], never `HugeIcons` directly.
/// Swapping icon sets later touches this one file, not eight.
///
/// The constants are `List<List<dynamic>>` per Hugeicons' SVG-path data
/// format. Render them with the [HugeIcon] widget from the `hugeicons`
/// package:
///
/// ```dart
/// HugeIcon(icon: AppIcons.settings, size: 22, color: accent)
/// ```
///
/// `HugeIcon` also accepts `strokeWidth` — used to tune visual mass
/// independently of size, and applied consistently across the app.
class AppIcons {
  AppIcons._();

  // -------------------------------------------------------------------------
  // Global chrome
  // -------------------------------------------------------------------------

  /// UI-language selector (nav bar) and target-language rows.
  static const List<List<dynamic>> globe =
      HugeIcons.strokeRoundedGlobe;

  /// Theme toggle in light mode — "switch to dark".
  static const List<List<dynamic>> moon =
      HugeIcons.strokeRoundedMoon;

  /// Theme toggle in dark mode — "switch to light".
  static const List<List<dynamic>> sun =
      HugeIcons.strokeRoundedSun01;

  /// Settings entry.
  static const List<List<dynamic>> settings =
      HugeIcons.strokeRoundedSettings01;

  /// Right-pointing disclosure indicator on navigable rows.
  static const List<List<dynamic>> chevronForward =
      HugeIcons.strokeRoundedArrowRight01;

  // -------------------------------------------------------------------------
  // Home screen
  // -------------------------------------------------------------------------

  /// Primary action — open the native document scanner.
  static const List<List<dynamic>> scanDocument =
      HugeIcons.strokeRoundedScanText;

  /// Type-text entry.
  static const List<List<dynamic>> typeText =
      HugeIcons.strokeRoundedPencil;

  /// Import-a-file entry.
  static const List<List<dynamic>> importFile =
      HugeIcons.strokeRoundedFileUpload;

  /// Recent-scans row and History screen section headers.
  static const List<List<dynamic>> history =
      HugeIcons.strokeRoundedClock01;

  // -------------------------------------------------------------------------
  // Result screen
  // -------------------------------------------------------------------------

  /// Copy the current tab's text.
  static const List<List<dynamic>> copy =
      HugeIcons.strokeRoundedCopy01;

  /// Share the current tab's text.
  static const List<List<dynamic>> share =
      HugeIcons.strokeRoundedShare01;

  /// Overflow — export .txt / .pdf action sheet.
  static const List<List<dynamic>> more =
      HugeIcons.strokeRoundedMoreHorizontal;

  /// Error view leading icon.
  static const List<List<dynamic>> error =
      HugeIcons.strokeRoundedAlertCircle;

  // -------------------------------------------------------------------------
  // History screen
  // -------------------------------------------------------------------------

  /// Swipe-to-delete background on history rows.
  static const List<List<dynamic>> delete =
      HugeIcons.strokeRoundedDelete01;

  // -------------------------------------------------------------------------
  // Language pickers
  // -------------------------------------------------------------------------

  /// Search field icon in the target-language picker.
  static const List<List<dynamic>> search =
      HugeIcons.strokeRoundedSearch01;

  /// Selected-row checkmark in both pickers.
  static const List<List<dynamic>> check =
      HugeIcons.strokeRoundedCheck;

  /// "Follow system" row in the UI-language picker.
  static const List<List<dynamic>> smartphone =
      HugeIcons.strokeRoundedSmartPhone01;

  // -------------------------------------------------------------------------
  // Text-translate screen
  // -------------------------------------------------------------------------

  /// Close button in the Type-text nav bar.
  static const List<List<dynamic>> close =
      HugeIcons.strokeRoundedCancel01;

  // -------------------------------------------------------------------------
  // Settings screen
  // -------------------------------------------------------------------------

  /// Appearance section leading icon.
  static const List<List<dynamic>> palette =
      HugeIcons.strokeRoundedPaintBrush01;

  /// "Ads removed" status badge leading icon.
  static const List<List<dynamic>> verified =
      HugeIcons.strokeRoundedBadgeCheck;

  /// "Remove ads" purchase row.
  static const List<List<dynamic>> adsClick =
      HugeIcons.strokeRoundedHandPointingLeft01;

  /// "Restore purchase" row.
  static const List<List<dynamic>> restore =
      HugeIcons.strokeRoundedRefresh;

  /// Privacy-policy row.
  static const List<List<dynamic>> privacy =
      HugeIcons.strokeRoundedHand;

  /// Terms-of-service row.
  static const List<List<dynamic>> docText =
      HugeIcons.strokeRoundedDoc02;

  /// Support row.
  static const List<List<dynamic>> support =
      HugeIcons.strokeRoundedHelpCircle;

  /// Open-source-licenses row.
  static const List<List<dynamic>> code =
      HugeIcons.strokeRoundedSourceCode;

  /// About row.
  static const List<List<dynamic>> info =
      HugeIcons.strokeRoundedInformationCircle;
}
