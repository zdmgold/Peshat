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

  @override
  String get errorNoTextDetected => 'У зображенні не знайдено тексту';

  @override
  String get errorImageUnreadable => 'Не вдалося прочитати зображення';

  @override
  String get errorModelDownloadFailed => 'Не вдалося завантажити модель перекладу';

  @override
  String get errorUnsupportedLanguage => 'Ця мова поки не підтримується';

  @override
  String get errorOcrFailed => 'Розпізнавання тексту не вдалося';

  @override
  String get errorTranslationFailed => 'Переклад не вдався';

  @override
  String get errorTimeout => 'Операція тривала занадто довго';

  @override
  String get errorUnknown => 'Щось пішло не так';

  @override
  String get statusRecognizing => 'Читання тексту…';

  @override
  String get statusPreparingModel => 'Підготовка перекладу…';

  @override
  String get statusTranslating => 'Переклад…';

  @override
  String get sourceLabel => 'Оригінал';

  @override
  String get translationLabel => 'Переклад';

  @override
  String get retryButton => 'Спробувати ще раз';

  @override
  String get changeLanguageButton => 'Змінити мову';

  @override
  String get historyLabel => 'Історія';

  @override
  String get defaultLanguageLabel => 'Мова перекладу за замовчуванням';

  @override
  String get aboutLabel => 'Про застосунок';

  @override
  String get licensesLabel => 'Ліцензії з відкритим кодом';

  @override
  String get shareAppLabel => 'Поділитися застосунком';

  @override
  String get versionLabel => 'Версія';

  @override
  String get historyEmpty => 'Ще немає сканувань';

  @override
  String get historyClearConfirm => 'Видалити всю історію?';

  @override
  String get termsLink => 'Умови використання';

  @override
  String get tagline => 'Наведіть камеру на будь-який текст і зрозумійте його миттєво.';

  @override
  String get noResults => 'Немає результатів';

  @override
  String get copiedMessage => 'Скопійовано в буфер обміну';

  @override
  String get exportTxtAction => 'Експорт як текст';

  @override
  String get exportPdfAction => 'Експорт як PDF';

  @override
  String get translatedTo => 'Перекладено на';

  @override
  String get translateToLabel => 'Перекласти на';

  @override
  String get typeTextLabel => 'Введіть або вставте текст';

  @override
  String get importFileLabel => 'Імпортувати файл';

  @override
  String get recentScansLabel => 'Недавні сканування';

  @override
  String get seeAllLabel => 'Показати все';

  @override
  String get uiLanguageLabel => 'Мова застосунку';

  @override
  String get historyToday => 'Сьогодні';

  @override
  String get historyYesterday => 'Учора';

  @override
  String get historyOlder => 'Раніше';

  @override
  String get typeTextButtonLabel => 'Ввести текст';

  @override
  String get removeAdsSubtitle => 'Разова купівля';

  @override
  String get removeAdsShortLabel => 'Прибрати';

  @override
  String get charactersLabel => 'символів';

  @override
  String get clearHistoryLabel => 'Очистити всю історію';

  @override
  String get cameraLabel => 'Камера';
}
