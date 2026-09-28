// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Skanuj dokument';

  @override
  String get resultTitle => 'Wynik';

  @override
  String get copyAction => 'Kopiuj';

  @override
  String get shareAction => 'Udostępnij';

  @override
  String get saveAction => 'Zapisz';

  @override
  String get readyToScan => 'Gotowy do skanowania';

  @override
  String get selectLanguageTitle => 'Wybierz język';

  @override
  String get searchLanguagesHint => 'Szukaj języków...';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get adStatusLabel => 'Status reklam:';

  @override
  String get adsShownStatus => 'Reklamy aktywne';

  @override
  String get themeLabel => 'Motyw';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get removeAdsButton => 'Usuń reklamy';

  @override
  String get restorePurchaseButton => 'Przywróć zakup';

  @override
  String get privacyPolicyLink => 'Polityka prywatności';

  @override
  String get supportLink => 'Pomoc';

  @override
  String get adsRemovedBadge => 'Reklamy usunięte';

  @override
  String get semanticsAppIcon => 'Ikona aplikacji Peshat';

  @override
  String get semanticsScanButton => 'Przycisk skanowania dokumentu';

  @override
  String get semanticsSearchField => 'Szukaj języków';

  @override
  String get semanticsRemoveAds => 'Usuń reklamy';

  @override
  String get cameraUsageDescription => 'Peshat używa aparatu do skanowania i tłumaczenia tekstu. Obrazy są przetwarzane na urządzeniu i nie są przesyłane.';

  @override
  String get trackingUsageDescription => 'Używane do wyświetlania odpowiednich, niespersonalizowanych reklam w przypadku odmowy; spersonalizowanych reklam w przypadku zgody.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Nie znaleziono tekstu na obrazie';

  @override
  String get errorImageUnreadable => 'Nie można odczytać obrazu';

  @override
  String get errorModelDownloadFailed => 'Nie udało się pobrać modelu tłumaczenia';

  @override
  String get errorUnsupportedLanguage => 'Ten język nie jest jeszcze obsługiwany';

  @override
  String get errorOcrFailed => 'Rozpoznawanie tekstu nie powiodło się';

  @override
  String get errorTranslationFailed => 'Tłumaczenie nie powiodło się';

  @override
  String get errorTimeout => 'Operacja trwała zbyt długo';

  @override
  String get errorUnknown => 'Coś poszło nie tak';

  @override
  String get statusRecognizing => 'Odczyt tekstu…';

  @override
  String get statusPreparingModel => 'Przygotowywanie tłumaczenia…';

  @override
  String get statusTranslating => 'Tłumaczenie…';

  @override
  String get sourceLabel => 'Oryginał';

  @override
  String get translationLabel => 'Tłumaczenie';

  @override
  String get retryButton => 'Spróbuj ponownie';

  @override
  String get changeLanguageButton => 'Zmień język';

  @override
  String get historyLabel => 'Historia';

  @override
  String get defaultLanguageLabel => 'Domyślny język tłumaczenia';

  @override
  String get aboutLabel => 'O aplikacji';

  @override
  String get licensesLabel => 'Licencje open source';

  @override
  String get shareAppLabel => 'Udostępnij tę aplikację';

  @override
  String get versionLabel => 'Wersja';

  @override
  String get historyEmpty => 'Brak skanów';

  @override
  String get historyClearConfirm => 'Usunąć całą historię?';

  @override
  String get termsLink => 'Warunki korzystania';

  @override
  String get tagline => 'Skieruj kamerę na dowolny tekst i zrozum go natychmiast.';

  @override
  String get noResults => 'Brak wyników';

  @override
  String get copiedMessage => 'Skopiowano do schowka';

  @override
  String get exportTxtAction => 'Eksportuj jako tekst';

  @override
  String get exportPdfAction => 'Eksportuj jako PDF';

  @override
  String get translatedTo => 'Przetłumaczono na';

  @override
  String get translateToLabel => 'Przetłumacz na';

  @override
  String get typeTextLabel => 'Wpisz lub wklej tekst';

  @override
  String get importFileLabel => 'Importuj plik';

  @override
  String get recentScansLabel => 'Ostatnie skany';

  @override
  String get seeAllLabel => 'Zobacz wszystko';

  @override
  String get uiLanguageLabel => 'Język aplikacji';

  @override
  String get historyToday => 'Dzisiaj';

  @override
  String get historyYesterday => 'Wczoraj';

  @override
  String get historyOlder => 'Starsze';

  @override
  String get typeTextButtonLabel => 'Wpisz tekst';

  @override
  String get removeAdsSubtitle => 'Zakup jednorazowy';

  @override
  String get removeAdsShortLabel => 'Usuń';

  @override
  String get charactersLabel => 'znaków';

  @override
  String get clearHistoryLabel => 'Wyczyść całą historię';

  @override
  String get cameraLabel => 'Aparat';

  @override
  String get recentLanguagesLabel => 'Ostatnie';

  @override
  String get allLanguagesLabel => 'Wszystkie języki';

  @override
  String get noResultsSubtitle => 'Spróbuj innej pisowni.';
}
