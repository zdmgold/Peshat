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
}
