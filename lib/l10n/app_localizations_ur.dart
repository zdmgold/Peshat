// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'دستاویز اسکین کریں';

  @override
  String get resultTitle => 'نتیجہ';

  @override
  String get copyAction => 'کاپی کریں';

  @override
  String get shareAction => 'شیئر کریں';

  @override
  String get saveAction => 'محفوظ کریں';

  @override
  String get readyToScan => 'اسکین کے لیے تیار';

  @override
  String get selectLanguageTitle => 'زبان منتخب کریں';

  @override
  String get searchLanguagesHint => 'زبانیں تلاش کریں...';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get adStatusLabel => 'اشتہار کی حیثیت:';

  @override
  String get adsShownStatus => 'اشتہارات دکھائے جا رہے ہیں';

  @override
  String get themeLabel => 'تھیم';

  @override
  String get themeLight => 'ہلکا';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeDark => 'گہرا';

  @override
  String get removeAdsButton => 'اشتہارات ہٹائیں';

  @override
  String get restorePurchaseButton => 'خریداری بحال کریں';

  @override
  String get privacyPolicyLink => 'رازداری کی پالیسی';

  @override
  String get supportLink => 'سپورٹ';

  @override
  String get adsRemovedBadge => 'اشتہارات ہٹا دیے گئے';

  @override
  String get semanticsAppIcon => 'Peshat ایپ آئیکن';

  @override
  String get semanticsScanButton => 'دستاویز اسکین بٹن';

  @override
  String get semanticsSearchField => 'زبانیں تلاش کریں';

  @override
  String get semanticsRemoveAds => 'اشتہارات ہٹائیں';

  @override
  String get cameraUsageDescription => 'Peshat متن کو اسکین اور ترجمہ کرنے کے لیے کیمرہ استعمال کرتا ہے۔ تصاویر ڈیوائس پر پروسیس ہوتی ہیں اور اپ لوڈ نہیں کی جاتیں۔';

  @override
  String get trackingUsageDescription => 'اگر آپ انکار کرتے ہیں تو متعلقہ غیر ذاتی نوعیت کے اشتہارات دکھانے کے لیے استعمال ہوتا ہے؛ اگر آپ اجازت دیتے ہیں تو ذاتی نوعیت کے اشتہارات۔';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName، $nativeName';
  }
}
