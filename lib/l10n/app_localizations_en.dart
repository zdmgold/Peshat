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
  String get adStatusLabel => 'Ad Status:';

  @override
  String get adsShownStatus => 'Ads Shown';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get removeAdsButton => 'Remove Ads';

  @override
  String get restorePurchaseButton => 'Restore Purchase';

  @override
  String get privacyPolicyLink => 'Privacy Policy';

  @override
  String get supportLink => 'Support';

  @override
  String get adsRemovedBadge => 'Ads Removed';

  @override
  String get semanticsAppIcon => 'Peshat App Icon';

  @override
  String get semanticsScanButton => 'Scan Document Button';

  @override
  String get semanticsSearchField => 'Search languages';

  @override
  String get semanticsRemoveAds => 'Remove Ads';

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

  @override
  String get errorNoTextDetected => 'No text found in the image';

  @override
  String get errorImageUnreadable => 'The image could not be read';

  @override
  String get errorModelDownloadFailed => 'Translation model could not be downloaded';

  @override
  String get errorUnsupportedLanguage => 'This language is not supported yet';

  @override
  String get errorOcrFailed => 'Text recognition failed';

  @override
  String get errorTranslationFailed => 'Translation failed';

  @override
  String get errorTimeout => 'The operation took too long';

  @override
  String get errorUnknown => 'Something went wrong';

  @override
  String get statusRecognizing => 'Reading text…';

  @override
  String get statusPreparingModel => 'Preparing translation…';

  @override
  String get statusTranslating => 'Translating…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Translation';

  @override
  String get retryButton => 'Try again';

  @override
  String get changeLanguageButton => 'Change language';

  @override
  String get historyLabel => 'History';

  @override
  String get defaultLanguageLabel => 'Default translation language';

  @override
  String get aboutLabel => 'About';

  @override
  String get licensesLabel => 'Open-source licenses';

  @override
  String get shareAppLabel => 'Share this app';

  @override
  String get versionLabel => 'Version';

  @override
  String get historyEmpty => 'No scans yet';

  @override
  String get historyClearConfirm => 'Delete all history?';

  @override
  String get termsLink => 'Terms of Service';

  @override
  String get tagline => 'Point your camera at any text, understand it instantly.';

  @override
  String get noResults => 'No results';

  @override
  String get copiedMessage => 'Copied to clipboard';

  @override
  String get exportTxtAction => 'Export as text';

  @override
  String get exportPdfAction => 'Export as PDF';

  @override
  String get translatedTo => 'Translated to';

  @override
  String get translateToLabel => 'Translate to';

  @override
  String get typeTextLabel => 'Type or paste text';

  @override
  String get importFileLabel => 'Import a file';

  @override
  String get recentScansLabel => 'Recent scans';

  @override
  String get seeAllLabel => 'See all';

  @override
  String get uiLanguageLabel => 'App language';
}
