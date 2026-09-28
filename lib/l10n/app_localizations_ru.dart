// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Сканировать документ';

  @override
  String get resultTitle => 'Результат';

  @override
  String get copyAction => 'Копировать';

  @override
  String get shareAction => 'Поделиться';

  @override
  String get saveAction => 'Сохранить';

  @override
  String get readyToScan => 'Готов к сканированию';

  @override
  String get selectLanguageTitle => 'Выбрать язык';

  @override
  String get searchLanguagesHint => 'Поиск языков...';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get adStatusLabel => 'Статус рекламы:';

  @override
  String get adsShownStatus => 'Реклама показывается';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Темная';

  @override
  String get removeAdsButton => 'Убрать рекламу';

  @override
  String get restorePurchaseButton => 'Восстановить покупку';

  @override
  String get privacyPolicyLink => 'Политика конфиденциальности';

  @override
  String get supportLink => 'Поддержка';

  @override
  String get adsRemovedBadge => 'Реклама отключена';

  @override
  String get semanticsAppIcon => 'Значок приложения Peshat';

  @override
  String get semanticsScanButton => 'Кнопка сканирования документа';

  @override
  String get semanticsSearchField => 'Поиск языков';

  @override
  String get semanticsRemoveAds => 'Убрать рекламу';

  @override
  String get cameraUsageDescription => 'Peshat использует камеру для сканирования и перевода текста. Изображения обрабатываются на устройстве и не загружаются.';

  @override
  String get trackingUsageDescription => 'Используется для показа релевантной неперсонализированной рекламы, если вы отказались, или персонализированной рекламы, если вы согласились.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'В изображении не найден текст';

  @override
  String get errorImageUnreadable => 'Не удалось прочитать изображение';

  @override
  String get errorModelDownloadFailed => 'Не удалось скачать модель перевода';

  @override
  String get errorUnsupportedLanguage => 'Этот язык пока не поддерживается';

  @override
  String get errorOcrFailed => 'Распознавание текста не удалось';

  @override
  String get errorTranslationFailed => 'Перевод не удался';

  @override
  String get errorTimeout => 'Операция заняла слишком много времени';

  @override
  String get errorUnknown => 'Что-то пошло не так';

  @override
  String get statusRecognizing => 'Чтение текста…';

  @override
  String get statusPreparingModel => 'Подготовка перевода…';

  @override
  String get statusTranslating => 'Перевод…';

  @override
  String get sourceLabel => 'Оригинал';

  @override
  String get translationLabel => 'Перевод';

  @override
  String get retryButton => 'Повторить';

  @override
  String get changeLanguageButton => 'Сменить язык';

  @override
  String get historyLabel => 'История';

  @override
  String get defaultLanguageLabel => 'Язык перевода по умолчанию';

  @override
  String get aboutLabel => 'О приложении';

  @override
  String get licensesLabel => 'Лицензии открытого исходного кода';

  @override
  String get shareAppLabel => 'Поделиться приложением';

  @override
  String get versionLabel => 'Версия';

  @override
  String get historyEmpty => 'Пока нет сканирований';

  @override
  String get historyClearConfirm => 'Удалить всю историю?';

  @override
  String get termsLink => 'Условия использования';
}
