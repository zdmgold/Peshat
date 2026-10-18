// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Skannaa asiakirja';

  @override
  String get resultTitle => 'Tulos';

  @override
  String get copyAction => 'Kopioi';

  @override
  String get shareAction => 'Jaa';

  @override
  String get saveAction => 'Tallenna';

  @override
  String get readyToScan => 'Valmis skannaamaan';

  @override
  String get selectLanguageTitle => 'Valitse kieli';

  @override
  String get searchLanguagesHint => 'Hae kieliä...';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get adStatusLabel => 'Mainosten tila';

  @override
  String get adsShownStatus => 'Mainokset näkyvissä';

  @override
  String get themeLabel => 'Teema';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeDark => 'Tumma';

  @override
  String get removeAdsButton => 'Poista mainokset';

  @override
  String get restorePurchaseButton => 'Palauta osto';

  @override
  String get privacyPolicyLink => 'Tietosuojakäytäntö';

  @override
  String get supportLink => 'Tuki';

  @override
  String get adsRemovedBadge => 'Mainokset poistettu';

  @override
  String get semanticsAppIcon => 'Peshat-sovelluskuvake';

  @override
  String get semanticsScanButton => 'Asiakirjan skannauspainike';

  @override
  String get semanticsSearchField => 'Hae kieliä';

  @override
  String get semanticsRemoveAds => 'Poista mainokset';

  @override
  String get cameraUsageDescription => 'Peshat käyttää kameraa tekstin skannaamiseen käännöstä varten. Kuvat käsitellään laitteella, eikä niitä lähetetä minnekään.';

  @override
  String get trackingUsageDescription => 'Käytetään näyttämään olennaisia, ei-personoituja mainoksia, jos kieltäydyt, ja personoituja mainoksia, jos sallit.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Kuvasta ei löytynyt tekstiä';

  @override
  String get errorImageUnreadable => 'Kuvaa ei voitu lukea';

  @override
  String get errorModelDownloadFailed => 'Kielipakettia ei voitu vastaanottaa. Tarkista internetyhteytesi ja yritä uudelleen.';

  @override
  String get errorUnsupportedLanguage => 'Tätä kieltä ei tueta vielä';

  @override
  String get errorOcrFailed => 'Tekstintunnistus epäonnistui';

  @override
  String get errorTranslationFailed => 'Käännös epäonnistui';

  @override
  String get errorTimeout => 'Toiminto kesti liian kauan';

  @override
  String get errorUnknown => 'Jokin meni pieleen';

  @override
  String get statusRecognizing => 'Luetaan tekstiä…';

  @override
  String get statusPreparingModel => 'Valmistellaan käännöstä…';

  @override
  String get statusTranslating => 'Käännetään…';

  @override
  String get sourceLabel => 'Alkuperäinen';

  @override
  String get translationLabel => 'Käännös';

  @override
  String get retryButton => 'Yritä uudelleen';

  @override
  String get changeLanguageButton => 'Vaihda kieli';

  @override
  String get historyLabel => 'Historia';

  @override
  String get defaultLanguageLabel => 'Oletuskäännöskieli';

  @override
  String get aboutLabel => 'Tietoja';

  @override
  String get licensesLabel => 'Avoimen lähdekoodin lisenssit';

  @override
  String get shareAppLabel => 'Jaa tämä sovellus';

  @override
  String get versionLabel => 'Versio';

  @override
  String get historyEmpty => 'Ei vielä skannauksia';

  @override
  String get historyClearConfirm => 'Poistetaanko koko historia?';

  @override
  String get termsLink => 'Käyttöehdot';

  @override
  String get tagline => 'Suuntaa kamera mihin tahansa tekstiin ja ymmärrä se heti.';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get copiedMessage => 'Kopioitu leikepöydälle';

  @override
  String get exportTxtAction => 'Vie tekstinä';

  @override
  String get exportPdfAction => 'Vie PDF-tiedostona';

  @override
  String get translatedTo => 'Käännetty kielelle';

  @override
  String get translatedFrom => 'Käännetty kielestä';

  @override
  String get scanLatinHint => 'Tarkimman käännöksen saat Kirjoita teksti -toiminnolla. Skannaus ja tuonti toimivat parhaiten selkeällä latinalaisilla kirjaimilla kirjoitetulla tekstillä.';

  @override
  String get sourceLanguageLabel => 'Lähdekieli';

  @override
  String get destinationLanguageLabel => 'Kohdekieli';

  @override
  String get languageAuto => 'Automaattinen';

  @override
  String get languageAutoLatin => 'Automaattinen (latinalaiset kirjaimet)';

  @override
  String get pickerCameraReads => 'Kamera osaa lukea';

  @override
  String get pickerTypeOnly => 'Vain kirjoitus tai liittäminen';

  @override
  String get cameraCannotReadLanguage => 'Kamera ei osaa lukea tätä kieltä. Käytä Kirjoita teksti -toimintoa.';

  @override
  String get scanResultNote => 'Skannattu teksti voi sisältää virheitä. Tarkimman käännöksen saat Kirjoita teksti -toiminnolla.';

  @override
  String get translateToLabel => 'Käännä kielelle';

  @override
  String get typeTextLabel => 'Kirjoita tai liitä teksti';

  @override
  String get importFileLabel => 'Tuo tiedosto';

  @override
  String get recentScansLabel => 'Viimeisimmät skannaukset';

  @override
  String get seeAllLabel => 'Näytä kaikki';

  @override
  String get uiLanguageLabel => 'Sovelluksen kieli';

  @override
  String get historyToday => 'Tänään';

  @override
  String get historyYesterday => 'Eilen';

  @override
  String get historyOlder => 'Vanhemmat';

  @override
  String get typeTextButtonLabel => 'Kirjoita teksti';

  @override
  String get removeAdsSubtitle => 'Kertaosto';

  @override
  String get removeAdsShortLabel => 'Poista';

  @override
  String get charactersLabel => 'merkkiä';

  @override
  String get clearHistoryLabel => 'Tyhjennä koko historia';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get recentLanguagesLabel => 'Viimeisimmät';

  @override
  String get allLanguagesLabel => 'Kaikki kielet';

  @override
  String get noResultsSubtitle => 'Kokeile toista kirjoitusasua.';

  @override
  String get sectionSystemLabel => 'Järjestelmä';

  @override
  String get appLanguageLabel => 'Sovelluksen kieli';

  @override
  String get clearTextConfirm => 'Tyhjennetäänkö teksti?';

  @override
  String get historyEmptySubtitle => 'Kääntämäsi skannaukset näkyvät tässä.';

  @override
  String get cancelButtonLabel => 'Peruuta';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Sulje';

  @override
  String get showMenuTooltip => 'Näytä valikko';

  @override
  String get licensePackageLabel => 'Paketti';

  @override
  String get licenseEmptyLabel => 'Lisenssitietoja ei ole saatavilla.';

  @override
  String get rateAppLabel => 'Arvioi Peshat';

  @override
  String get notificationsSectionLabel => 'Ilmoitukset';

  @override
  String get reminderNotificationsLabel => 'Muistutukset';

  @override
  String get reminderNotificationsSubtitle => 'Saat muistutuksen, jos et ole käyttänyt Peshatia muutamaan päivään.';

  @override
  String get reminderNotificationTitle => 'Jatka käännöksiäsi';

  @override
  String get reminderNotificationBody => 'Jatka siitä, mihin jäit, Peshatin kanssa.';

  @override
  String get notificationPermissionDenied => 'Ota ilmoitukset käyttöön järjestelmän asetuksissa saadaksesi muistutuksia.';

  @override
  String get scanShortLabel => 'Skannaa';

  @override
  String get recentLabel => 'Viimeisimmät';

  @override
  String get purchaseUnavailable => 'Ostot eivät ole nyt käytettävissä. Yritä myöhemmin uudelleen.';

  @override
  String get restoreChecking => 'Tarkistetaan aiempia ostoja…';

  @override
  String get adPrivacyChoices => 'Mainosten tietosuojavalinnat';

  @override
  String get followSystemLabel => 'Seuraa järjestelmää';

  @override
  String get couldNotOpenLink => 'Linkkiä ei voitu avata';

  @override
  String get pdfFontDownloading => 'Vastaanotetaan fonttia tälle PDF:lle…';

  @override
  String get pdfFontDownloadFailed => 'Tämän PDF:n fonttia ei voitu vastaanottaa. Tarkista internetyhteytesi ja yritä uudelleen.';

  @override
  String get packReceivingTitle => 'Vastaanotetaan kielipakettia…';

  @override
  String get packReceivedTitle => 'Paketti vastaanotettu';

  @override
  String get errorOfflinePackNeeded => 'Ei internetyhteyttä. Tämä kieli tarvitsee kertaluonteisen paketin vastaanottamisen. Muodosta internetyhteys ja yritä uudelleen.';

  @override
  String get errorPackTooSlow => 'Kielipaketin vastaanottaminen kestää liian kauan. Internetyhteytesi voi olla heikko. Yritä uudelleen.';

  @override
  String get errorNoTextHint => 'Tarkimman käännöksen saat Kirjoita teksti -toiminnolla. Skannaus ja tuonti toimivat parhaiten selkeällä latinalaisilla kirjaimilla kirjoitetulla tekstillä.';
}
