// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'اسکن سند';

  @override
  String get resultTitle => 'نتیجه';

  @override
  String get copyAction => 'کپی';

  @override
  String get shareAction => 'اشتراک‌گذاری';

  @override
  String get saveAction => 'ذخیره';

  @override
  String get readyToScan => 'آماده اسکن';

  @override
  String get selectLanguageTitle => 'انتخاب زبان';

  @override
  String get searchLanguagesHint => 'جستجوی زبان‌ها...';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get adStatusLabel => 'وضعیت تبلیغات:';

  @override
  String get adsShownStatus => 'تبلیغات نمایش داده می‌شود';

  @override
  String get themeLabel => 'تم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeDark => 'تیره';

  @override
  String get removeAdsButton => 'حذف تبلیغات';

  @override
  String get restorePurchaseButton => 'بازیابی خرید';

  @override
  String get privacyPolicyLink => 'سیاست حفظ حریم خصوصی';

  @override
  String get supportLink => 'پشتیبانی';

  @override
  String get adsRemovedBadge => 'تبلیغات حذف شد';

  @override
  String get semanticsAppIcon => 'آیکون برنامه Peshat';

  @override
  String get semanticsScanButton => 'دکمه اسکن سند';

  @override
  String get semanticsSearchField => 'جستجوی زبان‌ها';

  @override
  String get semanticsRemoveAds => 'حذف تبلیغات';

  @override
  String get cameraUsageDescription => 'Peshat از دوربین برای اسکن و ترجمه متن استفاده می‌کند. تصاویر روی دستگاه پردازش می‌شوند و آپلود نمی‌شوند.';

  @override
  String get trackingUsageDescription => 'برای نمایش تبلیغات غیرشخصی‌سازی‌شده مرتبط در صورت رد کردن؛ و تبلیغات شخصی‌سازی‌شده در صورت موافقت استفاده می‌شود.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName، $nativeName';
  }

  @override
  String get errorNoTextDetected => 'متنی در تصویر یافت نشد';

  @override
  String get errorImageUnreadable => 'تصویر خوانده نشد';

  @override
  String get errorModelDownloadFailed => 'مدل ترجمه دانلود نشد';

  @override
  String get errorUnsupportedLanguage => 'این زبان هنوز پشتیبانی نمی‌شود';

  @override
  String get errorOcrFailed => 'تشخیص متن ناموفق بود';

  @override
  String get errorTranslationFailed => 'ترجمه ناموفق بود';

  @override
  String get errorTimeout => 'عملیات بیش از حد طول کشید';

  @override
  String get errorUnknown => 'خطایی رخ داد';

  @override
  String get statusRecognizing => 'در حال خواندن متن…';

  @override
  String get statusPreparingModel => 'در حال آماده‌سازی ترجمه…';

  @override
  String get statusTranslating => 'در حال ترجمه…';

  @override
  String get sourceLabel => 'اصل';

  @override
  String get translationLabel => 'ترجمه';

  @override
  String get retryButton => 'دوباره تلاش کنید';

  @override
  String get changeLanguageButton => 'تغییر زبان';

  @override
  String get historyLabel => 'تاریخچه';

  @override
  String get defaultLanguageLabel => 'زبان ترجمه پیش‌فرض';

  @override
  String get aboutLabel => 'درباره';

  @override
  String get licensesLabel => 'مجوزهای متن‌باز';

  @override
  String get shareAppLabel => 'اشتراک‌گذاری این برنامه';

  @override
  String get versionLabel => 'نسخه';

  @override
  String get historyEmpty => 'هنوز اسکنی وجود ندارد';

  @override
  String get historyClearConfirm => 'همه تاریخچه حذف شود؟';

  @override
  String get termsLink => 'شرایط استفاده از خدمات';

  @override
  String get tagline => 'دوربین را به سمت هر متنی بگیرید و فوراً آن را بفهمید.';

  @override
  String get noResults => 'نتیجه‌ای یافت نشد';
}
