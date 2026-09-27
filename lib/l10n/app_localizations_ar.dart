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
}
