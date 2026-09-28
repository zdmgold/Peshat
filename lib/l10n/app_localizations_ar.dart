// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'مسح مستند';

  @override
  String get resultTitle => 'النتيجة';

  @override
  String get copyAction => 'نسخ';

  @override
  String get shareAction => 'مشاركة';

  @override
  String get saveAction => 'حفظ';

  @override
  String get readyToScan => 'جاهز للمسح';

  @override
  String get selectLanguageTitle => 'اختر اللغة';

  @override
  String get searchLanguagesHint => 'ابحث عن اللغات...';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get adStatusLabel => 'حالة الإعلانات:';

  @override
  String get adsShownStatus => 'الإعلانات معروضة';

  @override
  String get themeLabel => 'السمة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeDark => 'داكن';

  @override
  String get removeAdsButton => 'إزالة الإعلانات';

  @override
  String get restorePurchaseButton => 'استعادة الشراء';

  @override
  String get privacyPolicyLink => 'سياسة الخصوصية';

  @override
  String get supportLink => 'الدعم';

  @override
  String get adsRemovedBadge => 'تمت إزالة الإعلانات';

  @override
  String get semanticsAppIcon => 'أيقونة تطبيق Peshat';

  @override
  String get semanticsScanButton => 'زر مسح مستند';

  @override
  String get semanticsSearchField => 'ابحث عن اللغات';

  @override
  String get semanticsRemoveAds => 'إزالة الإعلانات';

  @override
  String get cameraUsageDescription => 'يستخدم Peshat الكاميرا لمسح النص وترجمته. تتم معالجة الصور على الجهاز ولا يتم رفعها.';

  @override
  String get trackingUsageDescription => 'يُستخدم لعرض إعلانات غير مخصصة ذات صلة في حال الرفض؛ وإعلانات مخصصة في حال الموافقة.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName، $nativeName';
  }

  @override
  String get errorNoTextDetected => 'لم يتم العثور على نص في الصورة';

  @override
  String get errorImageUnreadable => 'تعذر قراءة الصورة';

  @override
  String get errorModelDownloadFailed => 'تعذر تنزيل نموذج الترجمة';

  @override
  String get errorUnsupportedLanguage => 'هذه اللغة غير مدعومة بعد';

  @override
  String get errorOcrFailed => 'فشل التعرف على النص';

  @override
  String get errorTranslationFailed => 'فشلت الترجمة';

  @override
  String get errorTimeout => 'استغرقت العملية وقتًا طويلاً';

  @override
  String get errorUnknown => 'حدث خطأ ما';

  @override
  String get statusRecognizing => 'جارٍ قراءة النص…';

  @override
  String get statusPreparingModel => 'جارٍ تحضير الترجمة…';

  @override
  String get statusTranslating => 'جارٍ الترجمة…';

  @override
  String get sourceLabel => 'الأصل';

  @override
  String get translationLabel => 'الترجمة';

  @override
  String get retryButton => 'حاول مرة أخرى';

  @override
  String get changeLanguageButton => 'تغيير اللغة';

  @override
  String get historyLabel => 'السجل';

  @override
  String get defaultLanguageLabel => 'لغة الترجمة الافتراضية';

  @override
  String get aboutLabel => 'حول';

  @override
  String get licensesLabel => 'تراخيص المصدر المفتوح';

  @override
  String get shareAppLabel => 'شارك هذا التطبيق';

  @override
  String get versionLabel => 'الإصدار';
}
