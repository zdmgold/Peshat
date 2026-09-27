// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Сканувати документ';

  @override
  String get resultTitle => 'Результат';

  @override
  String get copyAction => 'Копіювати';

  @override
  String get shareAction => 'Поділитися';

  @override
  String get saveAction => 'Зберегти';

  @override
  String get readyToScan => 'Готовий до сканування';

  @override
  String get selectLanguageTitle => 'Вибрати мову';

  @override
  String get searchLanguagesHint => 'Пошук мов...';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get adStatusLabel => 'Статус реклами:';

  @override
  String get adsShownStatus => 'Реклама показується';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeDark => 'Темна';

  @override
  String get removeAdsButton => 'Прибрати рекламу';

  @override
  String get restorePurchaseButton => 'Відновити покупку';

  @override
  String get privacyPolicyLink => 'Політика конфіденційності';

  @override
  String get supportLink => 'Підтримка';

  @override
  String get adsRemovedBadge => 'Рекламу вимкнено';

  @override
  String get semanticsAppIcon => 'Значок додатку Peshat';

  @override
  String get semanticsScanButton => 'Кнопка сканування документа';

  @override
  String get semanticsSearchField => 'Пошук мов';

  @override
  String get semanticsRemoveAds => 'Прибрати рекламу';

  @override
  String get cameraUsageDescription => 'Peshat використовує камеру для сканування та перекладу тексту. Зображення обробляються на пристрої та не завантажуються.';

  @override
  String get trackingUsageDescription => 'Використовується для показу релевантної неперсоналізованої реклами, якщо ви відмовилися, або персоналізованої реклами, якщо ви погодилися.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
