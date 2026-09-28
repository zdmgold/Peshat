import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_km.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_my.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fil'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('km'),
    Locale('ko'),
    Locale('lo'),
    Locale('my'),
    Locale('ne'),
    Locale('nl'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('si'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Peshat'**
  String get appName;

  /// No description provided for @scanButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanButtonLabel;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @copyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAction;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @readyToScan.
  ///
  /// In en, this message translates to:
  /// **'Ready to scan'**
  String get readyToScan;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @searchLanguagesHint.
  ///
  /// In en, this message translates to:
  /// **'Search languages...'**
  String get searchLanguagesHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @adStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Ad Status:'**
  String get adStatusLabel;

  /// No description provided for @adsShownStatus.
  ///
  /// In en, this message translates to:
  /// **'Ads Shown'**
  String get adsShownStatus;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @removeAdsButton.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAdsButton;

  /// No description provided for @restorePurchaseButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get restorePurchaseButton;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLink;

  /// No description provided for @supportLink.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportLink;

  /// No description provided for @adsRemovedBadge.
  ///
  /// In en, this message translates to:
  /// **'Ads Removed'**
  String get adsRemovedBadge;

  /// No description provided for @semanticsAppIcon.
  ///
  /// In en, this message translates to:
  /// **'Peshat App Icon'**
  String get semanticsAppIcon;

  /// No description provided for @semanticsScanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Document Button'**
  String get semanticsScanButton;

  /// No description provided for @semanticsSearchField.
  ///
  /// In en, this message translates to:
  /// **'Search languages'**
  String get semanticsSearchField;

  /// No description provided for @semanticsRemoveAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get semanticsRemoveAds;

  /// No description provided for @cameraUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'Peshat uses the camera to scan text for translation. Images are processed on-device and are not uploaded.'**
  String get cameraUsageDescription;

  /// No description provided for @trackingUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'Used to show relevant, non-personalized ads if you decline; personalized ads if you allow.'**
  String get trackingUsageDescription;

  /// No description provided for @nativeAppName.
  ///
  /// In en, this message translates to:
  /// **'Peshat'**
  String get nativeAppName;

  /// No description provided for @semanticsLanguageEntry.
  ///
  /// In en, this message translates to:
  /// **'{englishName}, {nativeName}'**
  String semanticsLanguageEntry(String englishName, String nativeName);

  /// No description provided for @errorNoTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text found in the image'**
  String get errorNoTextDetected;

  /// No description provided for @errorImageUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The image could not be read'**
  String get errorImageUnreadable;

  /// No description provided for @errorModelDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation model could not be downloaded'**
  String get errorModelDownloadFailed;

  /// No description provided for @errorUnsupportedLanguage.
  ///
  /// In en, this message translates to:
  /// **'This language is not supported yet'**
  String get errorUnsupportedLanguage;

  /// No description provided for @errorOcrFailed.
  ///
  /// In en, this message translates to:
  /// **'Text recognition failed'**
  String get errorOcrFailed;

  /// No description provided for @errorTranslationFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation failed'**
  String get errorTranslationFailed;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The operation took too long'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorUnknown;

  /// No description provided for @statusRecognizing.
  ///
  /// In en, this message translates to:
  /// **'Reading text…'**
  String get statusRecognizing;

  /// No description provided for @statusPreparingModel.
  ///
  /// In en, this message translates to:
  /// **'Preparing translation…'**
  String get statusPreparingModel;

  /// No description provided for @statusTranslating.
  ///
  /// In en, this message translates to:
  /// **'Translating…'**
  String get statusTranslating;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get sourceLabel;

  /// No description provided for @translationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationLabel;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryButton;

  /// No description provided for @changeLanguageButton.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageButton;

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @defaultLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Default translation language'**
  String get defaultLanguageLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @licensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licensesLabel;

  /// No description provided for @shareAppLabel.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get shareAppLabel;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get historyEmpty;

  /// No description provided for @historyClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all history?'**
  String get historyClearConfirm;

  /// No description provided for @termsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsLink;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at any text, understand it instantly.'**
  String get tagline;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @copiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedMessage;

  /// No description provided for @exportTxtAction.
  ///
  /// In en, this message translates to:
  /// **'Export as text'**
  String get exportTxtAction;

  /// No description provided for @exportPdfAction.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportPdfAction;

  /// No description provided for @translatedTo.
  ///
  /// In en, this message translates to:
  /// **'Translated to'**
  String get translatedTo;

  /// No description provided for @translateToLabel.
  ///
  /// In en, this message translates to:
  /// **'Translate to'**
  String get translateToLabel;

  /// No description provided for @typeTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Type or paste text'**
  String get typeTextLabel;

  /// No description provided for @importFileLabel.
  ///
  /// In en, this message translates to:
  /// **'Import a file'**
  String get importFileLabel;

  /// No description provided for @recentScansLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent scans'**
  String get recentScansLabel;

  /// No description provided for @seeAllLabel.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAllLabel;

  /// No description provided for @uiLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get uiLanguageLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['am', 'ar', 'bn', 'cs', 'de', 'el', 'en', 'es', 'fa', 'fil', 'fr', 'he', 'hi', 'hu', 'id', 'it', 'ja', 'km', 'ko', 'lo', 'my', 'ne', 'nl', 'pa', 'pl', 'pt', 'ro', 'ru', 'si', 'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am': return AppLocalizationsAm();
    case 'ar': return AppLocalizationsAr();
    case 'bn': return AppLocalizationsBn();
    case 'cs': return AppLocalizationsCs();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fa': return AppLocalizationsFa();
    case 'fil': return AppLocalizationsFil();
    case 'fr': return AppLocalizationsFr();
    case 'he': return AppLocalizationsHe();
    case 'hi': return AppLocalizationsHi();
    case 'hu': return AppLocalizationsHu();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'km': return AppLocalizationsKm();
    case 'ko': return AppLocalizationsKo();
    case 'lo': return AppLocalizationsLo();
    case 'my': return AppLocalizationsMy();
    case 'ne': return AppLocalizationsNe();
    case 'nl': return AppLocalizationsNl();
    case 'pa': return AppLocalizationsPa();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'si': return AppLocalizationsSi();
    case 'sv': return AppLocalizationsSv();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'ur': return AppLocalizationsUr();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
