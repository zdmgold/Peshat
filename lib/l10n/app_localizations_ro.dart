// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Scanează documentul';

  @override
  String get resultTitle => 'Rezultat';

  @override
  String get copyAction => 'Copiază';

  @override
  String get shareAction => 'Partajează';

  @override
  String get saveAction => 'Salvează';

  @override
  String get readyToScan => 'Gata de scanare';

  @override
  String get selectLanguageTitle => 'Selectează limba';

  @override
  String get searchLanguagesHint => 'Caută limbi...';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get adStatusLabel => 'Starea reclamelor:';

  @override
  String get adsShownStatus => 'Reclame afișate';

  @override
  String get themeLabel => 'Temă';

  @override
  String get themeLight => 'Deschisă';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Întunecată';

  @override
  String get removeAdsButton => 'Elimină reclamele';

  @override
  String get restorePurchaseButton => 'Restabilește achiziția';

  @override
  String get privacyPolicyLink => 'Politica de confidențialitate';

  @override
  String get supportLink => 'Asistență';

  @override
  String get adsRemovedBadge => 'Reclame eliminate';

  @override
  String get semanticsAppIcon => 'Pictograma aplicației Peshat';

  @override
  String get semanticsScanButton => 'Butonul Scanează documentul';

  @override
  String get semanticsSearchField => 'Caută limbi';

  @override
  String get semanticsRemoveAds => 'Elimină reclamele';

  @override
  String get cameraUsageDescription => 'Peshat folosește camera pentru a scana și traduce textul. Imaginile sunt procesate pe dispozitiv și nu sunt încărcate.';

  @override
  String get trackingUsageDescription => 'Folosit pentru a afișa reclame relevante, nepersonalizate dacă refuzați; reclame personalizate dacă acceptați.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Nu s-a găsit text în imagine';

  @override
  String get errorImageUnreadable => 'Imaginea nu a putut fi citită';

  @override
  String get errorModelDownloadFailed => 'Modelul de traducere nu a putut fi descărcat';

  @override
  String get errorUnsupportedLanguage => 'Această limbă nu este încă acceptată';

  @override
  String get errorOcrFailed => 'Recunoașterea textului a eșuat';

  @override
  String get errorTranslationFailed => 'Traducerea a eșuat';

  @override
  String get errorTimeout => 'Operațiunea a durat prea mult';

  @override
  String get errorUnknown => 'Ceva a mers greșit';

  @override
  String get statusRecognizing => 'Se citește textul…';

  @override
  String get statusPreparingModel => 'Se pregătește traducerea…';

  @override
  String get statusTranslating => 'Se traduce…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Traducere';

  @override
  String get retryButton => 'Încearcă din nou';

  @override
  String get changeLanguageButton => 'Schimbă limba';

  @override
  String get historyLabel => 'Istoric';

  @override
  String get defaultLanguageLabel => 'Limbă de traducere implicită';

  @override
  String get aboutLabel => 'Despre';

  @override
  String get licensesLabel => 'Licențe open source';

  @override
  String get shareAppLabel => 'Distribuie această aplicație';

  @override
  String get versionLabel => 'Versiune';

  @override
  String get historyEmpty => 'Încă nicio scanare';

  @override
  String get historyClearConfirm => 'Ștergeți tot istoricul?';

  @override
  String get termsLink => 'Termeni și condiții';

  @override
  String get tagline => 'Îndreptați camera spre orice text și înțelegeți-l instant.';

  @override
  String get noResults => 'Fără rezultate';

  @override
  String get copiedMessage => 'Copiat în clipboard';

  @override
  String get exportTxtAction => 'Exportați ca text';

  @override
  String get exportPdfAction => 'Exportați ca PDF';

  @override
  String get translatedTo => 'Tradus în';

  @override
  String get translateToLabel => 'Tradu în';

  @override
  String get typeTextLabel => 'Tastați sau lipiți text';

  @override
  String get importFileLabel => 'Importați un fișier';

  @override
  String get recentScansLabel => 'Scanări recente';

  @override
  String get seeAllLabel => 'Vezi tot';

  @override
  String get uiLanguageLabel => 'Limba aplicației';

  @override
  String get historyToday => 'Astăzi';

  @override
  String get historyYesterday => 'Ieri';

  @override
  String get historyOlder => 'Mai vechi';

  @override
  String get typeTextButtonLabel => 'Introduceți text';

  @override
  String get removeAdsSubtitle => 'Achiziție unică';

  @override
  String get removeAdsShortLabel => 'Elimină';

  @override
  String get charactersLabel => 'caractere';

  @override
  String get clearHistoryLabel => 'Șterge tot istoricul';

  @override
  String get cameraLabel => 'Cameră';

  @override
  String get recentLanguagesLabel => 'Recente';

  @override
  String get allLanguagesLabel => 'Toate limbile';

  @override
  String get noResultsSubtitle => 'Încercați altă ortografie.';

  @override
  String get sectionSystemLabel => 'Sistem';

  @override
  String get appLanguageLabel => 'Limba aplicației';

  @override
  String get clearTextConfirm => 'Ștergeți textul?';
}
