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
}
