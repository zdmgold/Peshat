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
}
