// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Document scannen';

  @override
  String get resultTitle => 'Resultaat';

  @override
  String get copyAction => 'Kopiëren';

  @override
  String get shareAction => 'Delen';

  @override
  String get saveAction => 'Opslaan';

  @override
  String get readyToScan => 'Klaar om te scannen';

  @override
  String get selectLanguageTitle => 'Taal selecteren';

  @override
  String get searchLanguagesHint => 'Talen zoeken...';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get adStatusLabel => 'Advertentiestatus:';

  @override
  String get adsShownStatus => 'Advertenties weergegeven';

  @override
  String get themeLabel => 'Thema';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeDark => 'Donker';

  @override
  String get removeAdsButton => 'Advertenties verwijderen';

  @override
  String get restorePurchaseButton => 'Aankoop herstellen';

  @override
  String get privacyPolicyLink => 'Privacybeleid';

  @override
  String get supportLink => 'Ondersteuning';

  @override
  String get adsRemovedBadge => 'Advertenties verwijderd';

  @override
  String get semanticsAppIcon => 'Peshat app-pictogram';

  @override
  String get semanticsScanButton => 'Knop Document scannen';

  @override
  String get semanticsSearchField => 'Talen zoeken';

  @override
  String get semanticsRemoveAds => 'Advertenties verwijderen';

  @override
  String get cameraUsageDescription => 'Peshat gebruikt de camera om tekst te scannen en te vertalen. Afbeeldingen worden op het apparaat verwerkt en niet geüpload.';

  @override
  String get trackingUsageDescription => 'Wordt gebruikt om relevante, niet-gepersonaliseerde advertenties weer te geven als u weigert; gepersonaliseerde advertenties als u toestemt.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Geen tekst gevonden in de afbeelding';

  @override
  String get errorImageUnreadable => 'De afbeelding kon niet worden gelezen';

  @override
  String get errorModelDownloadFailed => 'Vertaalmodel kon niet worden gedownload';

  @override
  String get errorUnsupportedLanguage => 'Deze taal wordt nog niet ondersteund';

  @override
  String get errorOcrFailed => 'Tekstherkenning mislukt';

  @override
  String get errorTranslationFailed => 'Vertaling mislukt';

  @override
  String get errorTimeout => 'De bewerking duurde te lang';

  @override
  String get errorUnknown => 'Er is iets misgegaan';

  @override
  String get statusRecognizing => 'Tekst lezen…';

  @override
  String get statusPreparingModel => 'Vertaling voorbereiden…';

  @override
  String get statusTranslating => 'Vertalen…';

  @override
  String get sourceLabel => 'Origineel';

  @override
  String get translationLabel => 'Vertaling';

  @override
  String get retryButton => 'Opnieuw proberen';

  @override
  String get changeLanguageButton => 'Taal wijzigen';

  @override
  String get historyLabel => 'Geschiedenis';

  @override
  String get defaultLanguageLabel => 'Standaard vertaaltaal';

  @override
  String get aboutLabel => 'Over';

  @override
  String get licensesLabel => 'Open-source licenties';

  @override
  String get shareAppLabel => 'Deze app delen';

  @override
  String get versionLabel => 'Versie';

  @override
  String get historyEmpty => 'Nog geen scans';

  @override
  String get historyClearConfirm => 'Alle geschiedenis verwijderen?';

  @override
  String get termsLink => 'Servicevoorwaarden';

  @override
  String get tagline => 'Richt je camera op een willekeurige tekst en begrijp die direct.';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get copiedMessage => 'Gekopieerd naar klembord';

  @override
  String get exportTxtAction => 'Exporteren als tekst';

  @override
  String get exportPdfAction => 'Exporteren als PDF';

  @override
  String get translatedTo => 'Vertaald naar';

  @override
  String get translateToLabel => 'Vertalen naar';

  @override
  String get typeTextLabel => 'Typ of plak tekst';

  @override
  String get importFileLabel => 'Een bestand importeren';

  @override
  String get recentScansLabel => 'Recente scans';

  @override
  String get seeAllLabel => 'Alles bekijken';

  @override
  String get uiLanguageLabel => 'App-taal';

  @override
  String get historyToday => 'Vandaag';

  @override
  String get historyYesterday => 'Gisteren';

  @override
  String get historyOlder => 'Ouder';

  @override
  String get typeTextButtonLabel => 'Tekst typen';

  @override
  String get removeAdsSubtitle => 'Eenmalige aankoop';

  @override
  String get removeAdsShortLabel => 'Verwijderen';

  @override
  String get charactersLabel => 'tekens';

  @override
  String get clearHistoryLabel => 'Alle geschiedenis wissen';

  @override
  String get cameraLabel => 'Camera';
}
