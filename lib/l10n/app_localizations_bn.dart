// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'নথি স্ক্যান করুন';

  @override
  String get resultTitle => 'ফলাফল';

  @override
  String get copyAction => 'কপি করুন';

  @override
  String get shareAction => 'শেয়ার করুন';

  @override
  String get saveAction => 'সংরক্ষণ করুন';

  @override
  String get readyToScan => 'স্ক্যান করার জন্য প্রস্তুত';

  @override
  String get selectLanguageTitle => 'ভাষা নির্বাচন করুন';

  @override
  String get searchLanguagesHint => 'ভাষা খুঁজুন...';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get adStatusLabel => 'বিজ্ঞাপনের অবস্থা:';

  @override
  String get adsShownStatus => 'বিজ্ঞাপন দেখানো হচ্ছে';

  @override
  String get themeLabel => 'থিম';

  @override
  String get themeLight => 'হালকা';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeDark => 'গাঢ়';

  @override
  String get removeAdsButton => 'বিজ্ঞাপন সরান';

  @override
  String get restorePurchaseButton => 'ক্রয় পুনরুদ্ধার করুন';

  @override
  String get privacyPolicyLink => 'গোপনীয়তা নীতি';

  @override
  String get supportLink => 'সহায়তা';

  @override
  String get adsRemovedBadge => 'বিজ্ঞাপন সরানো হয়েছে';

  @override
  String get semanticsAppIcon => 'Peshat অ্যাপ আইকন';

  @override
  String get semanticsScanButton => 'নথি স্ক্যান বোতাম';

  @override
  String get semanticsSearchField => 'ভাষা খুঁজুন';

  @override
  String get semanticsRemoveAds => 'বিজ্ঞাপন সরান';

  @override
  String get cameraUsageDescription => 'Peshat পাঠ্য স্ক্যান এবং অনুবাদ করার জন্য ক্যামেরা ব্যবহার করে। ছবিগুলি ডিভাইসে প্রক্রিয়া করা হয় এবং আপলোড করা হয় না।';

  @override
  String get trackingUsageDescription => 'আপনি অস্বীকার করলে প্রাসঙ্গিক অ-ব্যক্তিগতকৃত বিজ্ঞাপন দেখানোর জন্য ব্যবহৃত হয়; আপনি সম্মত হলে ব্যক্তিগতকৃত বিজ্ঞাপন।';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'ছবিতে কোনো টেক্সট পাওয়া যায়নি';

  @override
  String get errorImageUnreadable => 'ছবিটি পড়া যায়নি';

  @override
  String get errorModelDownloadFailed => 'অনুবাদ মডেল ডাউনলোড করা যায়নি';

  @override
  String get errorUnsupportedLanguage => 'এই ভাষা এখনো সমর্থিত নয়';

  @override
  String get errorOcrFailed => 'টেক্সট শনাক্তকরণ ব্যর্থ';

  @override
  String get errorTranslationFailed => 'অনুবাদ ব্যর্থ';

  @override
  String get errorTimeout => 'কাজটি অনেক সময় নিয়েছে';

  @override
  String get errorUnknown => 'কিছু ভুল হয়েছে';

  @override
  String get statusRecognizing => 'টেক্সট পড়া হচ্ছে…';

  @override
  String get statusPreparingModel => 'অনুবাদ প্রস্তুত করা হচ্ছে…';

  @override
  String get statusTranslating => 'অনুবাদ করা হচ্ছে…';

  @override
  String get sourceLabel => 'মূল';

  @override
  String get translationLabel => 'অনুবাদ';

  @override
  String get retryButton => 'আবার চেষ্টা করুন';

  @override
  String get changeLanguageButton => 'ভাষা পরিবর্তন করুন';

  @override
  String get historyLabel => 'ইতিহাস';

  @override
  String get defaultLanguageLabel => 'ডিফল্ট অনুবাদ ভাষা';

  @override
  String get aboutLabel => 'সম্পর্কে';

  @override
  String get licensesLabel => 'ওপেন সোর্স লাইসেন্স';

  @override
  String get shareAppLabel => 'এই অ্যাপ শেয়ার করুন';

  @override
  String get versionLabel => 'সংস্করণ';

  @override
  String get historyEmpty => 'এখনো কোনো স্ক্যান নেই';

  @override
  String get historyClearConfirm => 'সব ইতিহাস মুছবেন?';

  @override
  String get termsLink => 'পরিষেবার শর্তাবলী';
}
