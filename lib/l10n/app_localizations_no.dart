// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Skann dokument';

  @override
  String get resultTitle => 'Resultat';

  @override
  String get copyAction => 'Kopier';

  @override
  String get shareAction => 'Del';

  @override
  String get saveAction => 'Lagre';

  @override
  String get readyToScan => 'Klar til skanning';

  @override
  String get selectLanguageTitle => 'Velg språk';

  @override
  String get searchLanguagesHint => 'Søk etter språk...';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get adStatusLabel => 'Annonsestatus';

  @override
  String get adsShownStatus => 'Annonser vises';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Mørk';

  @override
  String get removeAdsButton => 'Fjern annonser';

  @override
  String get restorePurchaseButton => 'Gjenopprett kjøp';

  @override
  String get privacyPolicyLink => 'Personvernerklæring';

  @override
  String get supportLink => 'Støtte';

  @override
  String get adsRemovedBadge => 'Annonser fjernet';

  @override
  String get semanticsAppIcon => 'Peshat-appikon';

  @override
  String get semanticsScanButton => 'Knapp for å skanne dokument';

  @override
  String get semanticsSearchField => 'Søk etter språk';

  @override
  String get semanticsRemoveAds => 'Fjern annonser';

  @override
  String get cameraUsageDescription => 'Peshat bruker kameraet til å skanne tekst for oversettelse. Bilder behandles på enheten og lastes ikke opp.';

  @override
  String get trackingUsageDescription => 'Brukes til å vise relevante, ikke-personaliserte annonser hvis du avslår, og personaliserte annonser hvis du tillater det.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Fant ingen tekst i bildet';

  @override
  String get errorImageUnreadable => 'Bildet kunne ikke leses';

  @override
  String get errorModelDownloadFailed => 'Språkpakken kunne ikke mottas. Sjekk internettforbindelsen din og prøv igjen.';

  @override
  String get errorUnsupportedLanguage => 'Dette språket støttes ikke ennå';

  @override
  String get errorOcrFailed => 'Tekstgjenkjenning mislyktes';

  @override
  String get errorTranslationFailed => 'Oversettelsen mislyktes';

  @override
  String get errorTimeout => 'Operasjonen tok for lang tid';

  @override
  String get errorUnknown => 'Noe gikk galt';

  @override
  String get statusRecognizing => 'Leser tekst…';

  @override
  String get statusPreparingModel => 'Forbereder oversettelse…';

  @override
  String get statusTranslating => 'Oversetter…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Oversettelse';

  @override
  String get retryButton => 'Prøv igjen';

  @override
  String get changeLanguageButton => 'Bytt språk';

  @override
  String get historyLabel => 'Historikk';

  @override
  String get defaultLanguageLabel => 'Standardspråk for oversettelse';

  @override
  String get aboutLabel => 'Om';

  @override
  String get licensesLabel => 'Åpen kildekode-lisenser';

  @override
  String get shareAppLabel => 'Del denne appen';

  @override
  String get versionLabel => 'Versjon';

  @override
  String get historyEmpty => 'Ingen skanninger ennå';

  @override
  String get historyClearConfirm => 'Slette all historikk?';

  @override
  String get termsLink => 'Vilkår for bruk';

  @override
  String get tagline => 'Pek kameraet mot en tekst og forstå den med en gang.';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get copiedMessage => 'Kopiert til utklippstavlen';

  @override
  String get exportTxtAction => 'Eksporter som tekst';

  @override
  String get exportPdfAction => 'Eksporter som PDF';

  @override
  String get translatedTo => 'Oversatt til';

  @override
  String get translateToLabel => 'Oversett til';

  @override
  String get typeTextLabel => 'Skriv eller lim inn tekst';

  @override
  String get importFileLabel => 'Importer en fil';

  @override
  String get recentScansLabel => 'Siste skanninger';

  @override
  String get seeAllLabel => 'Se alle';

  @override
  String get uiLanguageLabel => 'Appspråk';

  @override
  String get historyToday => 'I dag';

  @override
  String get historyYesterday => 'I går';

  @override
  String get historyOlder => 'Eldre';

  @override
  String get typeTextButtonLabel => 'Skriv tekst';

  @override
  String get removeAdsSubtitle => 'Engangskjøp';

  @override
  String get removeAdsShortLabel => 'Fjern';

  @override
  String get charactersLabel => 'tegn';

  @override
  String get clearHistoryLabel => 'Tøm all historikk';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get recentLanguagesLabel => 'Nylige';

  @override
  String get allLanguagesLabel => 'Alle språk';

  @override
  String get noResultsSubtitle => 'Prøv en annen stavemåte.';

  @override
  String get sectionSystemLabel => 'System';

  @override
  String get appLanguageLabel => 'Appspråk';

  @override
  String get clearTextConfirm => 'Tømme teksten?';

  @override
  String get historyEmptySubtitle => 'Skanninger du oversetter vises her.';

  @override
  String get cancelButtonLabel => 'Avbryt';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Lukk';

  @override
  String get showMenuTooltip => 'Vis meny';

  @override
  String get licensePackageLabel => 'Pakke';

  @override
  String get licenseEmptyLabel => 'Ingen lisensinformasjon tilgjengelig.';

  @override
  String get rateAppLabel => 'Vurder Peshat';

  @override
  String get notificationsSectionLabel => 'Varsler';

  @override
  String get reminderNotificationsLabel => 'Påminnelser';

  @override
  String get reminderNotificationsSubtitle => 'Få en påminnelse hvis du ikke har brukt Peshat på noen dager.';

  @override
  String get reminderNotificationTitle => 'Fortsett oversettelsene dine';

  @override
  String get reminderNotificationBody => 'Fortsett der du slapp med Peshat.';

  @override
  String get notificationPermissionDenied => 'Slå på varsler i systeminnstillingene for å motta påminnelser.';

  @override
  String get scanShortLabel => 'Skann';

  @override
  String get recentLabel => 'Nylige';

  @override
  String get purchaseUnavailable => 'Kjøp er ikke tilgjengelige akkurat nå. Prøv igjen senere.';

  @override
  String get restoreChecking => 'Ser etter tidligere kjøp…';

  @override
  String get adPrivacyChoices => 'Personvernvalg for annonser';

  @override
  String get followSystemLabel => 'Følg systemet';

  @override
  String get couldNotOpenLink => 'Kunne ikke åpne lenken';

  @override
  String get pdfFontDownloading => 'Mottar skrifttype for denne PDF-en…';

  @override
  String get pdfFontDownloadFailed => 'Skrifttypen for denne PDF-en kunne ikke mottas. Sjekk internettforbindelsen din og prøv igjen.';

  @override
  String get packReceivingTitle => 'Mottar språkpakke…';

  @override
  String get packReceivedTitle => 'Pakke mottatt';

  @override
  String get errorOfflinePackNeeded => 'Ingen internettforbindelse. Dette språket trenger en pakke som mottas én gang. Koble til internett og prøv igjen.';

  @override
  String get errorPackTooSlow => 'Det tar for lang tid å motta språkpakken. Internettforbindelsen din kan være svak. Prøv igjen.';

  @override
  String get errorNoTextHint => 'Kameraskanning leser latinsk, kinesisk, japansk, koreansk og devanagari-skrift. For andre skriftsystemer kan du skrive eller lime inn teksten i stedet.';
}
