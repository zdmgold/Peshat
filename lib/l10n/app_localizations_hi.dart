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
}
