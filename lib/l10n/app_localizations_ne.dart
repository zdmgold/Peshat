// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'कागजात स्क्यान गर्नुहोस्';

  @override
  String get resultTitle => 'नतिजा';

  @override
  String get copyAction => 'प्रतिलिपि गर्नुहोस्';

  @override
  String get shareAction => 'साझा गर्नुहोस्';

  @override
  String get saveAction => 'सुरक्षित गर्नुहोस्';

  @override
  String get readyToScan => 'स्क्यान गर्न तयार';

  @override
  String get selectLanguageTitle => 'भाषा चयन गर्नुहोस्';

  @override
  String get searchLanguagesHint => 'भाषाहरू खोज्नुहोस्...';

  @override
  String get settingsTitle => 'सेटिङहरू';

  @override
  String get adStatusLabel => 'विज्ञापन स्थिति:';

  @override
  String get adsShownStatus => 'विज्ञापनहरू देखाइँदै छन्';

  @override
  String get themeLabel => 'थिम';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeSystem => 'प्रणाली';

  @override
  String get themeDark => 'गाढा';

  @override
  String get removeAdsButton => 'विज्ञापन हटाउनुहोस्';

  @override
  String get restorePurchaseButton => 'खरिद पुनर्स्थापना गर्नुहोस्';

  @override
  String get privacyPolicyLink => 'गोपनीयता नीति';

  @override
  String get supportLink => 'समर्थन';

  @override
  String get adsRemovedBadge => 'विज्ञापन हटाइयो';

  @override
  String get semanticsAppIcon => 'Peshat एप आइकन';

  @override
  String get semanticsScanButton => 'कागजात स्क्यान बटन';

  @override
  String get semanticsSearchField => 'भाषाहरू खोज्नुहोस्';

  @override
  String get semanticsRemoveAds => 'विज्ञापन हटाउनुहोस्';

  @override
  String get cameraUsageDescription => 'Peshat ले पाठ स्क्यान र अनुवाद गर्न क्यामेरा प्रयोग गर्दछ। छविहरू उपकरणमा प्रशोधन गरिन्छ र अपलोड गरिँदैन।';

  @override
  String get trackingUsageDescription => 'यदि तपाईं अस्वीकार गर्नुहुन्छ भने सम्बन्धित गैर-व्यक्तिगत विज्ञापनहरू देखाउन प्रयोग गरिन्छ; यदि तपाईं सहमत हुनुहुन्छ भने व्यक्तिगत विज्ञापनहरू।';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'छविमा कुनै पाठ भेटिएन';

  @override
  String get errorImageUnreadable => 'छवि पढ्न सकिएन';

  @override
  String get errorModelDownloadFailed => 'अनुवाद मोडेल डाउनलोड गर्न सकिएन';

  @override
  String get errorUnsupportedLanguage => 'यो भाषा अझै समर्थित छैन';

  @override
  String get errorOcrFailed => 'पाठ पहिचान असफल';

  @override
  String get errorTranslationFailed => 'अनुवाद असफल';

  @override
  String get errorTimeout => 'कार्यले धेरै समय लियो';

  @override
  String get errorUnknown => 'केही गलत भयो';

  @override
  String get statusRecognizing => 'पाठ पढ्दै…';

  @override
  String get statusPreparingModel => 'अनुवाद तयार गर्दै…';

  @override
  String get statusTranslating => 'अनुवाद गर्दै…';

  @override
  String get sourceLabel => 'मूल';

  @override
  String get translationLabel => 'अनुवाद';

  @override
  String get retryButton => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get changeLanguageButton => 'भाषा परिवर्तन';

  @override
  String get historyLabel => 'इतिहास';

  @override
  String get defaultLanguageLabel => 'पूर्वनिर्धारित अनुवाद भाषा';

  @override
  String get aboutLabel => 'बारेमा';

  @override
  String get licensesLabel => 'खुला स्रोत इजाजतपत्र';

  @override
  String get shareAppLabel => 'यो एप साझा गर्नुहोस्';

  @override
  String get versionLabel => 'संस्करण';

  @override
  String get historyEmpty => 'अझै कुनै स्क्यान छैन';

  @override
  String get historyClearConfirm => 'सबै इतिहास मेटाउने?';

  @override
  String get termsLink => 'सेवाका सर्तहरू';
}
