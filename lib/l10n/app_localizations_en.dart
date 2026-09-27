// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Scan Document';

  @override
  String get resultTitle => 'Result';

  @override
  String get copyAction => 'Copy';

  @override
  String get shareAction => 'Share';

  @override
  String get saveAction => 'Save';

  @override
  String get readyToScan => 'Ready to scan';

  @override
  String get selectLanguageTitle => 'Select Language';

  @override
  String get searchLanguagesHint => 'Search languages...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get proStatusLabel => 'Pro Status:';

  @override
  String get freeStatus => 'Free';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get upgradeToProButton => 'Upgrade to Pro (Remove Ads)';

  @override
  String get restorePurchaseButton => 'Restore Purchase';

  @override
  String get privacyPolicyLink => 'Privacy Policy';

  @override
  String get supportLink => 'Support';

  @override
  String get proBadge => 'PRO';

  @override
  String get semanticsAppIcon => 'Peshat App Icon';

  @override
  String get semanticsScanButton => 'Scan Document Button';

  @override
  String get semanticsSearchField => 'Search languages';

  @override
  String get semanticsUpgrade => 'Upgrade to Pro';

  @override
  String get cameraUsageDescription => 'Peshat uses the camera to scan text for translation. Images are processed on-device and are not uploaded.';

  @override
  String get trackingUsageDescription => 'Used to show relevant, non-personalized ads if you decline; personalized ads if you allow.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
