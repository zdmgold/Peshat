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

  @override
  String get errorNoTextDetected => 'تصویر میں کوئی متن نہیں ملا';

  @override
  String get errorImageUnreadable => 'تصویر پڑھی نہیں جا سکی';

  @override
  String get errorModelDownloadFailed => 'ترجمہ ماڈل ڈاؤن لوڈ نہیں ہو سکا';

  @override
  String get errorUnsupportedLanguage => 'یہ زبان ابھی معاون نہیں';

  @override
  String get errorOcrFailed => 'متن کی شناخت ناکام';

  @override
  String get errorTranslationFailed => 'ترجمہ ناکام';

  @override
  String get errorTimeout => 'عمل میں بہت وقت لگا';

  @override
  String get errorUnknown => 'کچھ غلط ہو گیا';

  @override
  String get statusRecognizing => 'متن پڑھا جا رہا ہے…';

  @override
  String get statusPreparingModel => 'ترجمہ تیار کیا جا رہا ہے…';

  @override
  String get statusTranslating => 'ترجمہ ہو رہا ہے…';

  @override
  String get sourceLabel => 'اصل';

  @override
  String get translationLabel => 'ترجمہ';

  @override
  String get retryButton => 'دوبارہ کوشش کریں';

  @override
  String get changeLanguageButton => 'زبان تبدیل کریں';

  @override
  String get historyLabel => 'تاریخ';

  @override
  String get defaultLanguageLabel => 'پہلے سے طے شدہ ترجمہ زبان';

  @override
  String get aboutLabel => 'کے بارے میں';

  @override
  String get licensesLabel => 'اوپن سورس لائسنس';

  @override
  String get shareAppLabel => 'یہ ایپ شیئر کریں';

  @override
  String get versionLabel => 'ورژن';

  @override
  String get historyEmpty => 'ابھی کوئی اسکین نہیں';

  @override
  String get historyClearConfirm => 'تمام تاریخ حذف کریں؟';

  @override
  String get termsLink => 'شرائطِ خدمت';

  @override
  String get tagline => 'کیمرہ کسی بھی متن کی طرف کریں اور فوراً سمجھیں۔';

  @override
  String get noResults => 'کوئی نتیجہ نہیں';

  @override
  String get copiedMessage => 'کلپ بورڈ پر کاپی ہو گیا';

  @override
  String get exportTxtAction => 'متن کے طور پر ایکسپورٹ کریں';

  @override
  String get exportPdfAction => 'PDF کے طور پر ایکسپورٹ کریں';

  @override
  String get translatedTo => 'ترجمہ کیا گیا';

  @override
  String get translateToLabel => 'پر ترجمہ کریں';

  @override
  String get typeTextLabel => 'متن ٹائپ یا پیسٹ کریں';

  @override
  String get importFileLabel => 'فائل درآمد کریں';

  @override
  String get recentScansLabel => 'حالیہ اسکین';

  @override
  String get seeAllLabel => 'سب دیکھیں';

  @override
  String get uiLanguageLabel => 'ایپ کی زبان';
}
