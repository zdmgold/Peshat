// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Сканиране на документ';

  @override
  String get resultTitle => 'Резултат';

  @override
  String get copyAction => 'Копиране';

  @override
  String get shareAction => 'Споделяне';

  @override
  String get saveAction => 'Запазване';

  @override
  String get readyToScan => 'Готово за сканиране';

  @override
  String get selectLanguageTitle => 'Избор на език';

  @override
  String get searchLanguagesHint => 'Търсене на езици...';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get adStatusLabel => 'Състояние на рекламите';

  @override
  String get adsShownStatus => 'Показват се реклами';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeLight => 'Светла';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeDark => 'Тъмна';

  @override
  String get removeAdsButton => 'Премахване на рекламите';

  @override
  String get restorePurchaseButton => 'Възстановяване на покупка';

  @override
  String get privacyPolicyLink => 'Политика за поверителност';

  @override
  String get supportLink => 'Поддръжка';

  @override
  String get adsRemovedBadge => 'Рекламите са премахнати';

  @override
  String get semanticsAppIcon => 'Икона на приложението Peshat';

  @override
  String get semanticsScanButton => 'Бутон за сканиране на документ';

  @override
  String get semanticsSearchField => 'Търсене на езици';

  @override
  String get semanticsRemoveAds => 'Премахване на рекламите';

  @override
  String get cameraUsageDescription => 'Peshat използва камерата, за да сканира текст за превод. Изображенията се обработват на устройството и не се качват.';

  @override
  String get trackingUsageDescription => 'Използва се за показване на подходящи неперсонализирани реклами, ако откажете, и персонализирани реклами, ако разрешите.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'В изображението не е намерен текст';

  @override
  String get errorImageUnreadable => 'Изображението не можа да бъде прочетено';

  @override
  String get errorModelDownloadFailed => 'Езиковият пакет не можа да бъде получен. Проверете интернет връзката си и опитайте отново.';

  @override
  String get errorUnsupportedLanguage => 'Този език все още не се поддържа';

  @override
  String get errorOcrFailed => 'Разпознаването на текст не бе успешно';

  @override
  String get errorTranslationFailed => 'Преводът не бе успешен';

  @override
  String get errorTimeout => 'Операцията отне твърде много време';

  @override
  String get errorUnknown => 'Нещо се обърка';

  @override
  String get statusRecognizing => 'Четене на текста…';

  @override
  String get statusPreparingModel => 'Подготовка на превода…';

  @override
  String get statusTranslating => 'Превеждане…';

  @override
  String get sourceLabel => 'Оригинал';

  @override
  String get translationLabel => 'Превод';

  @override
  String get retryButton => 'Опитайте отново';

  @override
  String get changeLanguageButton => 'Смяна на езика';

  @override
  String get historyLabel => 'История';

  @override
  String get defaultLanguageLabel => 'Език за превод по подразбиране';

  @override
  String get aboutLabel => 'Относно';

  @override
  String get licensesLabel => 'Лицензи за софтуер с отворен код';

  @override
  String get shareAppLabel => 'Споделете това приложение';

  @override
  String get versionLabel => 'Версия';

  @override
  String get historyEmpty => 'Все още няма сканирания';

  @override
  String get historyClearConfirm => 'Да се изтрие ли цялата история?';

  @override
  String get termsLink => 'Условия за ползване';

  @override
  String get tagline => 'Насочете камерата към всеки текст и го разберете веднага.';

  @override
  String get noResults => 'Няма резултати';

  @override
  String get copiedMessage => 'Копирано в клипборда';

  @override
  String get exportTxtAction => 'Експортиране като текст';

  @override
  String get exportPdfAction => 'Експортиране като PDF';

  @override
  String get translatedTo => 'Преведено на';

  @override
  String get translatedFrom => 'Преведено от';

  @override
  String get scanLatinHint => 'За най-точен превод използвайте „Въведи текст“. Сканирането и импортът работят най-добре с ясен текст на латиница.';

  @override
  String get translateToLabel => 'Превеждане на';

  @override
  String get typeTextLabel => 'Въведете или поставете текст';

  @override
  String get importFileLabel => 'Импортиране на файл';

  @override
  String get recentScansLabel => 'Скорошни сканирания';

  @override
  String get seeAllLabel => 'Вижте всички';

  @override
  String get uiLanguageLabel => 'Език на приложението';

  @override
  String get historyToday => 'Днес';

  @override
  String get historyYesterday => 'Вчера';

  @override
  String get historyOlder => 'По-стари';

  @override
  String get typeTextButtonLabel => 'Въвеждане на текст';

  @override
  String get removeAdsSubtitle => 'Еднократна покупка';

  @override
  String get removeAdsShortLabel => 'Премахване';

  @override
  String get charactersLabel => 'знака';

  @override
  String get clearHistoryLabel => 'Изчистване на цялата история';

  @override
  String get cameraLabel => 'Камера';

  @override
  String get recentLanguagesLabel => 'Скорошни';

  @override
  String get allLanguagesLabel => 'Всички езици';

  @override
  String get noResultsSubtitle => 'Опитайте с различно изписване.';

  @override
  String get sectionSystemLabel => 'Система';

  @override
  String get appLanguageLabel => 'Език на приложението';

  @override
  String get clearTextConfirm => 'Да се изчисти ли текстът?';

  @override
  String get historyEmptySubtitle => 'Преведените от вас сканирания ще се показват тук.';

  @override
  String get cancelButtonLabel => 'Отказ';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Затваряне';

  @override
  String get showMenuTooltip => 'Показване на менюто';

  @override
  String get licensePackageLabel => 'Пакет';

  @override
  String get licenseEmptyLabel => 'Няма налична информация за лиценз.';

  @override
  String get rateAppLabel => 'Оценете Peshat';

  @override
  String get notificationsSectionLabel => 'Известия';

  @override
  String get reminderNotificationsLabel => 'Напомняния';

  @override
  String get reminderNotificationsSubtitle => 'Получете напомняне, ако не сте използвали Peshat от няколко дни.';

  @override
  String get reminderNotificationTitle => 'Продължете преводите си';

  @override
  String get reminderNotificationBody => 'Продължете оттам, докъдето сте стигнали, с Peshat.';

  @override
  String get notificationPermissionDenied => 'Разрешете известията в системните настройки, за да получавате напомняния.';

  @override
  String get scanShortLabel => 'Сканиране';

  @override
  String get recentLabel => 'Скорошни';

  @override
  String get purchaseUnavailable => 'Покупките не са налични в момента. Моля, опитайте отново по-късно.';

  @override
  String get restoreChecking => 'Проверка за предишни покупки…';

  @override
  String get adPrivacyChoices => 'Опции за поверителност на рекламите';

  @override
  String get followSystemLabel => 'Следване на системата';

  @override
  String get couldNotOpenLink => 'Връзката не можа да бъде отворена';

  @override
  String get pdfFontDownloading => 'Получава се шрифт за този PDF…';

  @override
  String get pdfFontDownloadFailed => 'Шрифтът за този PDF не можа да бъде получен. Проверете интернет връзката си и опитайте отново.';

  @override
  String get packReceivingTitle => 'Получава се езиков пакет…';

  @override
  String get packReceivedTitle => 'Пакетът е получен';

  @override
  String get errorOfflinePackNeeded => 'Няма връзка с интернет. Този език изисква еднократно получаване на пакет. Свържете се с интернет и опитайте отново.';

  @override
  String get errorPackTooSlow => 'Получаването на езиковия пакет отнема твърде дълго. Интернет връзката ви може да е слаба. Опитайте отново.';

  @override
  String get errorNoTextHint => 'За най-точен превод използвайте „Въведи текст“. Сканирането и импортът работят най-добре с ясен текст на латиница.';
}
