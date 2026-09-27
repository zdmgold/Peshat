// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'စာရွက်စာတမ်း စကင်ဖတ်ရန်';

  @override
  String get resultTitle => 'ရလဒ်';

  @override
  String get copyAction => 'ကူးယူရန်';

  @override
  String get shareAction => 'မျှဝေရန်';

  @override
  String get saveAction => 'သိမ်းဆည်းရန်';

  @override
  String get readyToScan => 'စကင်ဖတ်ရန် အဆင်သင့်';

  @override
  String get selectLanguageTitle => 'ဘာသာစကား ရွေးချယ်ရန်';

  @override
  String get searchLanguagesHint => 'ဘာသာစကားများ ရှာဖွေရန်...';

  @override
  String get settingsTitle => 'ဆက်တင်များ';

  @override
  String get adStatusLabel => 'ကြော်ငြာ အခြေအနေ:';

  @override
  String get adsShownStatus => 'ကြော်ငြာများ ပြသနေသည်';

  @override
  String get themeLabel => 'အပြင်အဆင်';

  @override
  String get themeLight => 'အလင်း';

  @override
  String get themeSystem => 'စနစ်';

  @override
  String get themeDark => 'အမှောင်';

  @override
  String get removeAdsButton => 'ကြော်ငြာများ ဖယ်ရှားရန်';

  @override
  String get restorePurchaseButton => 'ဝယ်ယူမှုကို ပြန်လည်ရယူရန်';

  @override
  String get privacyPolicyLink => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String get supportLink => 'ပံ့ပိုးကူညီမှု';

  @override
  String get adsRemovedBadge => 'ကြော်ငြာများ ဖယ်ရှားပြီး';

  @override
  String get semanticsAppIcon => 'Peshat အက်ပ် အိုင်ကွန်';

  @override
  String get semanticsScanButton => 'စာရွက်စာတမ်း စကင်ဖတ်ရန် ခလုတ်';

  @override
  String get semanticsSearchField => 'ဘာသာစကားများ ရှာဖွေရန်';

  @override
  String get semanticsRemoveAds => 'ကြော်ငြာများ ဖယ်ရှားရန်';

  @override
  String get cameraUsageDescription => 'Peshat သည် စာသားကို စကင်ဖတ်ပြီး ဘာသာပြန်ရန် ကင်မရာကို အသုံးပြုသည်။ ပုံများကို စက်ပစ္စည်းတွင် ပြုပြင်ပြီး အပ်လုဒ်တင်မည် မဟုတ်ပါ။';

  @override
  String get trackingUsageDescription => 'ငြင်းဆန်ပါက သက်ဆိုင်ရာ ကိုယ်ရေးကိုယ်တာမဟုတ်သော ကြော်ငြာများကို ပြသရန်၊ သဘောတူပါက ကိုယ်ရေးကိုယ်တာ ကြော်ငြာများကို ပြသရန် အသုံးပြုသည်။';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
