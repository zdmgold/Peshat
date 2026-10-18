// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'ஆவணத்தை ஸ்கேன் செய்';

  @override
  String get resultTitle => 'முடிவு';

  @override
  String get copyAction => 'நகலெடு';

  @override
  String get shareAction => 'பகிர்';

  @override
  String get saveAction => 'சேமி';

  @override
  String get readyToScan => 'ஸ்கேன் செய்யத் தயார்';

  @override
  String get selectLanguageTitle => 'மொழியைத் தேர்ந்தெடு';

  @override
  String get searchLanguagesHint => 'மொழிகளைத் தேடு...';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get adStatusLabel => 'விளம்பர நிலை';

  @override
  String get adsShownStatus => 'விளம்பரங்கள் காட்டப்படுகின்றன';

  @override
  String get themeLabel => 'தீம்';

  @override
  String get themeLight => 'ஒளி';

  @override
  String get themeSystem => 'சிஸ்டம்';

  @override
  String get themeDark => 'இருள்';

  @override
  String get removeAdsButton => 'விளம்பரங்களை நீக்கு';

  @override
  String get restorePurchaseButton => 'வாங்குதலை மீட்டெடு';

  @override
  String get privacyPolicyLink => 'தனியுரிமைக் கொள்கை';

  @override
  String get supportLink => 'ஆதரவு';

  @override
  String get adsRemovedBadge => 'விளம்பரங்கள் நீக்கப்பட்டன';

  @override
  String get semanticsAppIcon => 'Peshat ஆப் ஐகான்';

  @override
  String get semanticsScanButton => 'ஆவணத்தை ஸ்கேன் செய்யும் பொத்தான்';

  @override
  String get semanticsSearchField => 'மொழிகளைத் தேடு';

  @override
  String get semanticsRemoveAds => 'விளம்பரங்களை நீக்கு';

  @override
  String get cameraUsageDescription => 'மொழிபெயர்ப்பிற்காக உரையை ஸ்கேன் செய்ய Peshat கேமராவைப் பயன்படுத்துகிறது. படங்கள் சாதனத்திலேயே செயலாக்கப்படுகின்றன, பதிவேற்றப்படுவதில்லை.';

  @override
  String get trackingUsageDescription => 'நீங்கள் மறுத்தால் பொருத்தமான, தனிப்பயனாக்கப்படாத விளம்பரங்களையும், அனுமதித்தால் தனிப்பயனாக்கப்பட்ட விளம்பரங்களையும் காட்டப் பயன்படுகிறது.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'படத்தில் உரை எதுவும் கிடைக்கவில்லை';

  @override
  String get errorImageUnreadable => 'படத்தைப் படிக்க முடியவில்லை';

  @override
  String get errorModelDownloadFailed => 'மொழித் தொகுப்பைப் பெற முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get errorUnsupportedLanguage => 'இந்த மொழி இன்னும் ஆதரிக்கப்படவில்லை';

  @override
  String get errorOcrFailed => 'உரை அடையாளம் காணுதல் தோல்வியடைந்தது';

  @override
  String get errorTranslationFailed => 'மொழிபெயர்ப்பு தோல்வியடைந்தது';

  @override
  String get errorTimeout => 'செயல்பாட்டிற்கு அதிக நேரம் ஆனது';

  @override
  String get errorUnknown => 'ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get statusRecognizing => 'உரையைப் படிக்கிறது…';

  @override
  String get statusPreparingModel => 'மொழிபெயர்ப்பைத் தயார் செய்கிறது…';

  @override
  String get statusTranslating => 'மொழிபெயர்க்கிறது…';

  @override
  String get sourceLabel => 'மூலம்';

  @override
  String get translationLabel => 'மொழிபெயர்ப்பு';

  @override
  String get retryButton => 'மீண்டும் முயலவும்';

  @override
  String get changeLanguageButton => 'மொழியை மாற்று';

  @override
  String get historyLabel => 'வரலாறு';

  @override
  String get defaultLanguageLabel => 'இயல்பு மொழிபெயர்ப்பு மொழி';

  @override
  String get aboutLabel => 'பற்றி';

  @override
  String get licensesLabel => 'திறந்த மூல உரிமங்கள்';

  @override
  String get shareAppLabel => 'இந்த ஆப்ஸைப் பகிர்';

  @override
  String get versionLabel => 'பதிப்பு';

  @override
  String get historyEmpty => 'இன்னும் ஸ்கேன்கள் இல்லை';

  @override
  String get historyClearConfirm => 'எல்லா வரலாற்றையும் நீக்கவா?';

  @override
  String get termsLink => 'சேவை விதிமுறைகள்';

  @override
  String get tagline => 'எந்த உரையின் மீதும் கேமராவைக் காட்டுங்கள், உடனே புரிந்துகொள்ளுங்கள்.';

  @override
  String get noResults => 'முடிவுகள் இல்லை';

  @override
  String get copiedMessage => 'கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';

  @override
  String get exportTxtAction => 'உரையாக ஏற்றுமதி செய்';

  @override
  String get exportPdfAction => 'PDF ஆக ஏற்றுமதி செய்';

  @override
  String get translatedTo => 'மொழிபெயர்க்கப்பட்ட மொழி';

  @override
  String get translatedFrom => 'மொழிபெயர்க்கப்பட்ட மூலமொழி';

  @override
  String get scanLatinHint => 'மிகத் துல்லியமான மொழிபெயர்ப்புக்கு “உரையை உள்ளிடு” ஐப் பயன்படுத்தவும். ஸ்கேன் மற்றும் இறக்குமதி தெளிவான லத்தீன் எழுத்து உரையுடன் சிறப்பாக வேலை செய்யும்.';

  @override
  String get translateToLabel => 'மொழிபெயர்க்க வேண்டிய மொழி';

  @override
  String get typeTextLabel => 'உரையை உள்ளிடவும் அல்லது ஒட்டவும்';

  @override
  String get importFileLabel => 'கோப்பை இறக்குமதி செய்';

  @override
  String get recentScansLabel => 'சமீபத்திய ஸ்கேன்கள்';

  @override
  String get seeAllLabel => 'அனைத்தையும் காண்க';

  @override
  String get uiLanguageLabel => 'ஆப் மொழி';

  @override
  String get historyToday => 'இன்று';

  @override
  String get historyYesterday => 'நேற்று';

  @override
  String get historyOlder => 'பழையவை';

  @override
  String get typeTextButtonLabel => 'உரையை உள்ளிடு';

  @override
  String get removeAdsSubtitle => 'ஒருமுறை கட்டணம்';

  @override
  String get removeAdsShortLabel => 'நீக்கு';

  @override
  String get charactersLabel => 'எழுத்துகள்';

  @override
  String get clearHistoryLabel => 'எல்லா வரலாற்றையும் அழி';

  @override
  String get cameraLabel => 'கேமரா';

  @override
  String get recentLanguagesLabel => 'சமீபத்தியவை';

  @override
  String get allLanguagesLabel => 'அனைத்து மொழிகள்';

  @override
  String get noResultsSubtitle => 'வேறு எழுத்துக்கூட்டலை முயலவும்.';

  @override
  String get sectionSystemLabel => 'சிஸ்டம்';

  @override
  String get appLanguageLabel => 'ஆப் மொழி';

  @override
  String get clearTextConfirm => 'உரையை அழிக்கவா?';

  @override
  String get historyEmptySubtitle => 'நீங்கள் மொழிபெயர்க்கும் ஸ்கேன்கள் இங்கே தோன்றும்.';

  @override
  String get cancelButtonLabel => 'ரத்துசெய்';

  @override
  String get okButtonLabel => 'சரி';

  @override
  String get closeButtonTooltip => 'மூடு';

  @override
  String get showMenuTooltip => 'மெனுவைக் காட்டு';

  @override
  String get licensePackageLabel => 'தொகுப்பு';

  @override
  String get licenseEmptyLabel => 'உரிமத் தகவல் எதுவும் கிடைக்கவில்லை.';

  @override
  String get rateAppLabel => 'Peshat-ஐ மதிப்பிடுங்கள்';

  @override
  String get notificationsSectionLabel => 'அறிவிப்புகள்';

  @override
  String get reminderNotificationsLabel => 'நினைவூட்டல்கள்';

  @override
  String get reminderNotificationsSubtitle => 'சில நாட்களாக Peshat-ஐப் பயன்படுத்தவில்லை என்றால் நினைவூட்டலைப் பெறுங்கள்.';

  @override
  String get reminderNotificationTitle => 'உங்கள் மொழிபெயர்ப்புகளைத் தொடருங்கள்';

  @override
  String get reminderNotificationBody => 'Peshat உடன் நீங்கள் நிறுத்திய இடத்திலிருந்து தொடருங்கள்.';

  @override
  String get notificationPermissionDenied => 'நினைவூட்டல்களைப் பெற சிஸ்டம் அமைப்புகளில் அறிவிப்புகளை இயக்கவும்.';

  @override
  String get scanShortLabel => 'ஸ்கேன்';

  @override
  String get recentLabel => 'சமீபத்தியவை';

  @override
  String get purchaseUnavailable => 'வாங்குதல்கள் தற்போது கிடைக்கவில்லை. பிறகு மீண்டும் முயலவும்.';

  @override
  String get restoreChecking => 'முந்தைய வாங்குதல்களைச் சரிபார்க்கிறது…';

  @override
  String get adPrivacyChoices => 'விளம்பர தனியுரிமை விருப்பங்கள்';

  @override
  String get followSystemLabel => 'சிஸ்டத்தைப் பின்பற்று';

  @override
  String get couldNotOpenLink => 'இணைப்பைத் திறக்க முடியவில்லை';

  @override
  String get pdfFontDownloading => 'இந்த PDF-க்கான எழுத்துருவைப் பெறுகிறது…';

  @override
  String get pdfFontDownloadFailed => 'இந்த PDF-க்கான எழுத்துருவைப் பெற முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get packReceivingTitle => 'மொழித் தொகுப்பைப் பெறுகிறது…';

  @override
  String get packReceivedTitle => 'தொகுப்பு பெறப்பட்டது';

  @override
  String get errorOfflinePackNeeded => 'இணைய இணைப்பு இல்லை. இந்த மொழிக்கு ஒருமுறை பெற வேண்டிய தொகுப்பு தேவை. இணையத்துடன் இணைந்து மீண்டும் முயலவும்.';

  @override
  String get errorPackTooSlow => 'மொழித் தொகுப்பைப் பெற அதிக நேரம் ஆகிறது. உங்கள் இணைய இணைப்பு பலவீனமாக இருக்கலாம். மீண்டும் முயலவும்.';

  @override
  String get errorNoTextHint => 'மிகத் துல்லியமான மொழிபெயர்ப்புக்கு “உரையை உள்ளிடு” ஐப் பயன்படுத்தவும். ஸ்கேன் மற்றும் இறக்குமதி தெளிவான லத்தீன் எழுத்து உரையுடன் சிறப்பாக வேலை செய்யும்.';
}
