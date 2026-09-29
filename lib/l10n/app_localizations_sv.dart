// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Skanna dokument';

  @override
  String get resultTitle => 'Resultat';

  @override
  String get copyAction => 'Kopiera';

  @override
  String get shareAction => 'Dela';

  @override
  String get saveAction => 'Spara';

  @override
  String get readyToScan => 'Redo att skanna';

  @override
  String get selectLanguageTitle => 'Välj språk';

  @override
  String get searchLanguagesHint => 'Sök efter språk...';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get adStatusLabel => 'Annonsstatus:';

  @override
  String get adsShownStatus => 'Annonser visas';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get removeAdsButton => 'Ta bort annonser';

  @override
  String get restorePurchaseButton => 'Återställ köp';

  @override
  String get privacyPolicyLink => 'Integritetspolicy';

  @override
  String get supportLink => 'Support';

  @override
  String get adsRemovedBadge => 'Annonser borttagna';

  @override
  String get semanticsAppIcon => 'Peshat app-ikon';

  @override
  String get semanticsScanButton => 'Skanna dokument-knapp';

  @override
  String get semanticsSearchField => 'Sök efter språk';

  @override
  String get semanticsRemoveAds => 'Ta bort annonser';

  @override
  String get cameraUsageDescription => 'Peshat använder kameran för att skanna och översätta text. Bilder bearbetas på enheten och laddas inte upp.';

  @override
  String get trackingUsageDescription => 'Används för att visa relevanta, icke-personaliserade annonser om du avböjer; personliga annonser om du godkänner.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Ingen text hittades i bilden';

  @override
  String get errorImageUnreadable => 'Bilden kunde inte läsas';

  @override
  String get errorModelDownloadFailed => 'Översättningsmodellen kunde inte laddas ner';

  @override
  String get errorUnsupportedLanguage => 'Detta språk stöds inte ännu';

  @override
  String get errorOcrFailed => 'Textigenkänning misslyckades';

  @override
  String get errorTranslationFailed => 'Översättning misslyckades';

  @override
  String get errorTimeout => 'Åtgärden tog för lång tid';

  @override
  String get errorUnknown => 'Något gick fel';

  @override
  String get statusRecognizing => 'Läser text…';

  @override
  String get statusPreparingModel => 'Förbereder översättning…';

  @override
  String get statusTranslating => 'Översätter…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Översättning';

  @override
  String get retryButton => 'Försök igen';

  @override
  String get changeLanguageButton => 'Byt språk';

  @override
  String get historyLabel => 'Historik';

  @override
  String get defaultLanguageLabel => 'Standardöversättningsspråk';

  @override
  String get aboutLabel => 'Om';

  @override
  String get licensesLabel => 'Licenser för öppen källkod';

  @override
  String get shareAppLabel => 'Dela denna app';

  @override
  String get versionLabel => 'Version';

  @override
  String get historyEmpty => 'Inga skanningar än';

  @override
  String get historyClearConfirm => 'Radera all historik?';

  @override
  String get termsLink => 'Användarvillkor';

  @override
  String get tagline => 'Rikta kameran mot valfri text och förstå den direkt.';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get copiedMessage => 'Kopierat till urklipp';

  @override
  String get exportTxtAction => 'Exportera som text';

  @override
  String get exportPdfAction => 'Exportera som PDF';

  @override
  String get translatedTo => 'Översatt till';

  @override
  String get translateToLabel => 'Översätt till';

  @override
  String get typeTextLabel => 'Skriv eller klistra in text';

  @override
  String get importFileLabel => 'Importera en fil';

  @override
  String get recentScansLabel => 'Senaste skanningar';

  @override
  String get seeAllLabel => 'Visa alla';

  @override
  String get uiLanguageLabel => 'App-språk';

  @override
  String get historyToday => 'Idag';

  @override
  String get historyYesterday => 'Igår';

  @override
  String get historyOlder => 'Äldre';

  @override
  String get typeTextButtonLabel => 'Skriv text';

  @override
  String get removeAdsSubtitle => 'Engångsköp';

  @override
  String get removeAdsShortLabel => 'Ta bort';

  @override
  String get charactersLabel => 'tecken';

  @override
  String get clearHistoryLabel => 'Rensa all historik';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get recentLanguagesLabel => 'Senaste';

  @override
  String get allLanguagesLabel => 'Alla språk';

  @override
  String get noResultsSubtitle => 'Prova en annan stavning.';

  @override
  String get sectionSystemLabel => 'System';

  @override
  String get appLanguageLabel => 'App-språk';

  @override
  String get clearTextConfirm => 'Rensa texten?';

  @override
  String get historyEmptySubtitle => 'Skanningar du översätter visas här.';

  @override
  String get cancelButtonLabel => 'Avbryt';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Stäng';

  @override
  String get showMenuTooltip => 'Visa meny';

  @override
  String get licensePackageLabel => 'Paket';

  @override
  String get licenseEmptyLabel => 'Ingen licensinformation tillgänglig.';
}
