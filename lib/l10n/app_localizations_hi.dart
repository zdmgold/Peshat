// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'दस्तावेज़ स्कैन करें';

  @override
  String get resultTitle => 'परिणाम';

  @override
  String get copyAction => 'कॉपी करें';

  @override
  String get shareAction => 'साझा करें';

  @override
  String get saveAction => 'सहेजें';

  @override
  String get readyToScan => 'स्कैन करने के लिए तैयार';

  @override
  String get selectLanguageTitle => 'भाषा चुनें';

  @override
  String get searchLanguagesHint => 'भाषाएँ खोजें...';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get adStatusLabel => 'विज्ञापन स्थिति:';

  @override
  String get adsShownStatus => 'विज्ञापन दिखाए जा रहे हैं';

  @override
  String get themeLabel => 'थीम';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeDark => 'गहरा';

  @override
  String get removeAdsButton => 'विज्ञापन हटाएं';

  @override
  String get restorePurchaseButton => 'खरीदारी पुनर्स्थापित करें';

  @override
  String get privacyPolicyLink => 'गोपनीयता नीति';

  @override
  String get supportLink => 'सहायता';

  @override
  String get adsRemovedBadge => 'विज्ञापन हटाए गए';

  @override
  String get semanticsAppIcon => 'Peshat ऐप आइकन';

  @override
  String get semanticsScanButton => 'दस्तावेज़ स्कैन बटन';

  @override
  String get semanticsSearchField => 'भाषाएँ खोजें';

  @override
  String get semanticsRemoveAds => 'विज्ञापन हटाएं';

  @override
  String get cameraUsageDescription => 'Peshat टेक्स्ट स्कैन और अनुवाद करने के लिए कैमरा का उपयोग करता है। छवियां डिवाइस पर संसाधित होती हैं और अपलोड नहीं की जाती हैं।';

  @override
  String get trackingUsageDescription => 'यदि आप अस्वीकार करते हैं तो प्रासंगिक गैर-वैयक्तिकृत विज्ञापन दिखाने के लिए उपयोग किया जाता है; यदि आप सहमत हैं तो वैयक्तिकृत विज्ञापन।';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'छवि में कोई टेक्स्ट नहीं मिला';

  @override
  String get errorImageUnreadable => 'छवि पढ़ी नहीं जा सकी';

  @override
  String get errorModelDownloadFailed => 'अनुवाद मॉडल डाउनलोड नहीं हो सका';

  @override
  String get errorUnsupportedLanguage => 'यह भाषा अभी समर्थित नहीं है';

  @override
  String get errorOcrFailed => 'टेक्स्ट पहचान विफल';

  @override
  String get errorTranslationFailed => 'अनुवाद विफल';

  @override
  String get errorTimeout => 'कार्रवाई में बहुत समय लगा';

  @override
  String get errorUnknown => 'कुछ गलत हो गया';

  @override
  String get statusRecognizing => 'टेक्स्ट पढ़ा जा रहा है…';

  @override
  String get statusPreparingModel => 'अनुवाद तैयार किया जा रहा है…';

  @override
  String get statusTranslating => 'अनुवाद हो रहा है…';

  @override
  String get sourceLabel => 'मूल';

  @override
  String get translationLabel => 'अनुवाद';

  @override
  String get retryButton => 'पुनः प्रयास करें';

  @override
  String get changeLanguageButton => 'भाषा बदलें';

  @override
  String get historyLabel => 'इतिहास';

  @override
  String get defaultLanguageLabel => 'डिफ़ॉल्ट अनुवाद भाषा';

  @override
  String get aboutLabel => 'परिचय';

  @override
  String get licensesLabel => 'ओपन-सोर्स लाइसेंस';

  @override
  String get shareAppLabel => 'यह ऐप साझा करें';

  @override
  String get versionLabel => 'संस्करण';

  @override
  String get historyEmpty => 'अभी तक कोई स्कैन नहीं';

  @override
  String get historyClearConfirm => 'सारा इतिहास हटाएं?';

  @override
  String get termsLink => 'सेवा की शर्तें';

  @override
  String get tagline => 'कैमरे को किसी भी टेक्स्ट पर लक्षित करें और तुरंत समझें।';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String get copiedMessage => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get exportTxtAction => 'टेक्स्ट के रूप में निर्यात करें';

  @override
  String get exportPdfAction => 'PDF के रूप में निर्यात करें';

  @override
  String get translatedTo => 'अनुवादित';

  @override
  String get translateToLabel => 'इसमें अनुवाद करें';

  @override
  String get typeTextLabel => 'टेक्स्ट टाइप या पेस्ट करें';

  @override
  String get importFileLabel => 'फ़ाइल आयात करें';

  @override
  String get recentScansLabel => 'हाल के स्कैन';

  @override
  String get seeAllLabel => 'सभी देखें';

  @override
  String get uiLanguageLabel => 'ऐप भाषा';

  @override
  String get historyToday => 'आज';

  @override
  String get historyYesterday => 'कल';

  @override
  String get historyOlder => 'पुराना';

  @override
  String get typeTextButtonLabel => 'टेक्स्ट टाइप करें';

  @override
  String get removeAdsSubtitle => 'एकमुश्त खरीद';

  @override
  String get removeAdsShortLabel => 'हटाएं';

  @override
  String get charactersLabel => 'अक्षर';

  @override
  String get clearHistoryLabel => 'सारा इतिहास साफ़ करें';

  @override
  String get cameraLabel => 'कैमरा';

  @override
  String get recentLanguagesLabel => 'हाल के';

  @override
  String get allLanguagesLabel => 'सभी भाषाएँ';

  @override
  String get noResultsSubtitle => 'कोई दूसरी वर्तनी आज़माएँ।';

  @override
  String get sectionSystemLabel => 'सिस्टम';

  @override
  String get appLanguageLabel => 'ऐप भाषा';

  @override
  String get clearTextConfirm => 'टेक्स्ट साफ़ करें?';

  @override
  String get historyEmptySubtitle => 'आपके द्वारा अनुवादित स्कैन यहाँ दिखेंगे।';

  @override
  String get cancelButtonLabel => 'रद्द करें';

  @override
  String get okButtonLabel => 'ठीक है';

  @override
  String get closeButtonTooltip => 'बंद करें';

  @override
  String get showMenuTooltip => 'मेनू दिखाएँ';

  @override
  String get licensePackageLabel => 'पैकेज';

  @override
  String get licenseEmptyLabel => 'कोई लाइसेंस जानकारी उपलब्ध नहीं है।';

  @override
  String get rateAppLabel => 'Peshat को रेट करें';

  @override
  String get notificationsSectionLabel => 'सूचनाएँ';

  @override
  String get reminderNotificationsLabel => 'अनुस्मारक';

  @override
  String get reminderNotificationsSubtitle => 'यदि आपने कुछ दिनों से Peshat का उपयोग नहीं किया है तो अनुस्मारक प्राप्त करें।';

  @override
  String get reminderNotificationTitle => 'अपने अनुवाद जारी रखें';

  @override
  String get reminderNotificationBody => 'Peshat के साथ जहाँ छोड़ा था वहीं से जारी रखें।';

  @override
  String get notificationPermissionDenied => 'अनुस्मारक प्राप्त करने के लिए सिस्टम सेटिंग्स में सूचनाएँ सक्षम करें।';
}
