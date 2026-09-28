// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'I-scan ang dokumento';

  @override
  String get resultTitle => 'Resulta';

  @override
  String get copyAction => 'Kopyahin';

  @override
  String get shareAction => 'Ibahagi';

  @override
  String get saveAction => 'I-save';

  @override
  String get readyToScan => 'Handa na i-scan';

  @override
  String get selectLanguageTitle => 'Pumili ng wika';

  @override
  String get searchLanguagesHint => 'Maghanap ng mga wika...';

  @override
  String get settingsTitle => 'Mga setting';

  @override
  String get adStatusLabel => 'Status ng ad:';

  @override
  String get adsShownStatus => 'Ipinapakita ang mga ad';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Maliwanag';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Madilim';

  @override
  String get removeAdsButton => 'Tanggalin ang mga ad';

  @override
  String get restorePurchaseButton => 'I-restore ang pagbili';

  @override
  String get privacyPolicyLink => 'Patakaran sa privacy';

  @override
  String get supportLink => 'Suporta';

  @override
  String get adsRemovedBadge => 'Tinanggal ang mga ad';

  @override
  String get semanticsAppIcon => 'Icon ng app na Peshat';

  @override
  String get semanticsScanButton => 'Button ng I-scan ang dokumento';

  @override
  String get semanticsSearchField => 'Maghanap ng mga wika';

  @override
  String get semanticsRemoveAds => 'Tanggalin ang mga ad';

  @override
  String get cameraUsageDescription => 'Gumagamit ang Peshat ng camera upang i-scan at isalin ang teksto. Ang mga imahe ay pinoproseso sa device at hindi ina-upload.';

  @override
  String get trackingUsageDescription => 'Ginagamit upang ipakita ang mga kaugnay na non-personalized na ad kung tumatanggi ka; mga personalized na ad kung pumapayag ka.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Walang tekstong natagpuan sa larawan';

  @override
  String get errorImageUnreadable => 'Hindi mabasa ang larawan';

  @override
  String get errorModelDownloadFailed => 'Hindi ma-download ang modelo ng pagsasalin';

  @override
  String get errorUnsupportedLanguage => 'Hindi pa sinusuportahan ang wikang ito';

  @override
  String get errorOcrFailed => 'Nabigo ang pagkilala ng teksto';

  @override
  String get errorTranslationFailed => 'Nabigo ang pagsasalin';

  @override
  String get errorTimeout => 'Masyadong matagal ang operasyon';

  @override
  String get errorUnknown => 'May nangyaring mali';

  @override
  String get statusRecognizing => 'Binabasa ang teksto…';

  @override
  String get statusPreparingModel => 'Inihahanda ang pagsasalin…';

  @override
  String get statusTranslating => 'Isinasalin…';

  @override
  String get sourceLabel => 'Orihinal';

  @override
  String get translationLabel => 'Salin';

  @override
  String get retryButton => 'Subukan muli';

  @override
  String get changeLanguageButton => 'Palitan ang wika';

  @override
  String get historyLabel => 'Kasaysayan';

  @override
  String get defaultLanguageLabel => 'Default na wika ng pagsasalin';

  @override
  String get aboutLabel => 'Tungkol sa';

  @override
  String get licensesLabel => 'Mga lisensyang open-source';

  @override
  String get shareAppLabel => 'Ibahagi ang app na ito';

  @override
  String get versionLabel => 'Bersyon';

  @override
  String get historyEmpty => 'Wala pang mga scan';

  @override
  String get historyClearConfirm => 'Burahin lahat ng kasaysayan?';

  @override
  String get termsLink => 'Mga Tuntunin ng Serbisyo';
}
