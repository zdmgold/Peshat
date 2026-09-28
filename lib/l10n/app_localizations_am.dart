// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'ሰነድ ይቅኑ';

  @override
  String get resultTitle => 'ውጤት';

  @override
  String get copyAction => 'ቅዳ';

  @override
  String get shareAction => 'አጋራ';

  @override
  String get saveAction => 'አስቀምጥ';

  @override
  String get readyToScan => 'ለመቅረጽ ዝግጁ';

  @override
  String get selectLanguageTitle => 'ቋንቋ ይምረጡ';

  @override
  String get searchLanguagesHint => 'ቋንቋዎችን ይፈልጉ...';

  @override
  String get settingsTitle => 'ቅንብሮች';

  @override
  String get adStatusLabel => 'የማስታወቂያ ሁኔታ:';

  @override
  String get adsShownStatus => 'ማስታወቂያዎች ይታያሉ';

  @override
  String get themeLabel => 'ገጽታ';

  @override
  String get themeLight => 'ብሩህ';

  @override
  String get themeSystem => 'ስርዓት';

  @override
  String get themeDark => 'ጨለማ';

  @override
  String get removeAdsButton => 'ማስታወቂያዎችን አስወግድ';

  @override
  String get restorePurchaseButton => 'ግዢን መልሶ ያግኙ';

  @override
  String get privacyPolicyLink => 'የግላዊነት ፖሊሲ';

  @override
  String get supportLink => 'ድጋፍ';

  @override
  String get adsRemovedBadge => 'ማስታወቂያዎች ተወግደዋል';

  @override
  String get semanticsAppIcon => 'የPeshat መተግበሪያ አዶ';

  @override
  String get semanticsScanButton => 'ሰነድ የመቅረጽ ቁልፍ';

  @override
  String get semanticsSearchField => 'ቋንቋዎችን ይፈልጉ';

  @override
  String get semanticsRemoveAds => 'ማስታወቂያዎችን አስወግድ';

  @override
  String get cameraUsageDescription => 'Peshat ጽሑፍን ለመቅረጽ እና ለመተርጎም ካሜራን ይጠቀማል። ምስሎች በመሳሪያው ላይ ይሰራሉ እና አይሰቀሉም።';

  @override
  String get trackingUsageDescription => 'ካልተስማሙ ተገቢ ያልሆኑ ያልተለዩ ማስታወቂያዎችን ለማሳየት ያገለግላል፤ ከተስማሙ የተለዩ ማስታወቂያዎችን።';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'በምስሉ ውስጥ ጽሑፍ አልተገኘም';

  @override
  String get errorImageUnreadable => 'ምስሉን ማንበብ አልተቻለም';

  @override
  String get errorModelDownloadFailed => 'የትርጉም ሞዴል ማውረድ አልተቻለም';

  @override
  String get errorUnsupportedLanguage => 'ይህ ቋንቋ ገና አልተደገፈም';

  @override
  String get errorOcrFailed => 'የጽሑፍ ማወቂያ አልተሳካም';

  @override
  String get errorTranslationFailed => 'ትርጉም አልተሳካም';

  @override
  String get errorTimeout => 'ክዋኔው በጣም ረጅም ጊዜ ወሰደ';

  @override
  String get errorUnknown => 'የሆነ ስህተት ተከስቷል';

  @override
  String get statusRecognizing => 'ጽሑፍ በማንበብ ላይ…';

  @override
  String get statusPreparingModel => 'ትርጉም በማዘጋጀት ላይ…';

  @override
  String get statusTranslating => 'በመተርጎም ላይ…';

  @override
  String get sourceLabel => 'ዋናው';

  @override
  String get translationLabel => 'ትርጉም';

  @override
  String get retryButton => 'እንደገና ሞክር';

  @override
  String get changeLanguageButton => 'ቋንቋ ቀይር';

  @override
  String get historyLabel => 'ታሪክ';

  @override
  String get defaultLanguageLabel => 'ነባሪ የትርጉም ቋንቋ';

  @override
  String get aboutLabel => 'ስለ';

  @override
  String get licensesLabel => 'ክፍት ምንጭ ፈቃዶች';

  @override
  String get shareAppLabel => 'ይህን መተግበሪያ አጋራ';

  @override
  String get versionLabel => 'ስሪት';

  @override
  String get historyEmpty => 'እስካሁን ስካን የለም';

  @override
  String get historyClearConfirm => 'ሁሉንም ታሪክ ሰርዝ?';

  @override
  String get termsLink => 'የአገልግሎት ውሎች';

  @override
  String get tagline => 'ካሜራዎን ወደ ማንኛውም ጽሑፍ ያመላክቱ እና ወዲያውኑ ይረዱ።';

  @override
  String get noResults => 'ውጤት የለም';
}
