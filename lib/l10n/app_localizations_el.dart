// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Σάρωση εγγράφου';

  @override
  String get resultTitle => 'Αποτέλεσμα';

  @override
  String get copyAction => 'Αντιγραφή';

  @override
  String get shareAction => 'Κοινοποίηση';

  @override
  String get saveAction => 'Αποθήκευση';

  @override
  String get readyToScan => 'Έτοιμο για σάρωση';

  @override
  String get selectLanguageTitle => 'Επιλογή γλώσσας';

  @override
  String get searchLanguagesHint => 'Αναζήτηση γλωσσών...';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get adStatusLabel => 'Κατάσταση διαφημίσεων:';

  @override
  String get adsShownStatus => 'Οι διαφημίσεις εμφανίζονται';

  @override
  String get themeLabel => 'Θέμα';

  @override
  String get themeLight => 'Ανοιχτό';

  @override
  String get themeSystem => 'Σύστημα';

  @override
  String get themeDark => 'Σκούρο';

  @override
  String get removeAdsButton => 'Κατάργηση διαφημίσεων';

  @override
  String get restorePurchaseButton => 'Επαναφορά αγοράς';

  @override
  String get privacyPolicyLink => 'Πολιτική απορρήτου';

  @override
  String get supportLink => 'Υποστήριξη';

  @override
  String get adsRemovedBadge => 'Οι διαφημίσεις καταργήθηκαν';

  @override
  String get semanticsAppIcon => 'Εικονίδιο εφαρμογής Peshat';

  @override
  String get semanticsScanButton => 'Κουμπί σάρωσης εγγράφου';

  @override
  String get semanticsSearchField => 'Αναζήτηση γλωσσών';

  @override
  String get semanticsRemoveAds => 'Κατάργηση διαφημίσεων';

  @override
  String get cameraUsageDescription => 'Το Peshat χρησιμοποιεί την κάμερα για τη σάρωση και τη μετάφραση κειμένου. Οι εικόνες επεξεργάζονται στη συσκευή και δεν μεταφορτώνονται.';

  @override
  String get trackingUsageDescription => 'Χρησιμοποιείται για την εμφάνιση σχετικών, μη εξατομικευμένων διαφημίσεων εάν αρνηθείτε· εξατομικευμένων διαφημίσεων εάν συναινέσετε.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Δεν βρέθηκε κείμενο στην εικόνα';

  @override
  String get errorImageUnreadable => 'Δεν ήταν δυνατή η ανάγνωση της εικόνας';

  @override
  String get errorModelDownloadFailed => 'Δεν ήταν δυνατή η λήψη του μοντέλου μετάφρασης';

  @override
  String get errorUnsupportedLanguage => 'Αυτή η γλώσσα δεν υποστηρίζεται ακόμη';

  @override
  String get errorOcrFailed => 'Η αναγνώριση κειμένου απέτυχε';

  @override
  String get errorTranslationFailed => 'Η μετάφραση απέτυχε';

  @override
  String get errorTimeout => 'Η ενέργεια πήρε πολύ χρόνο';

  @override
  String get errorUnknown => 'Κάτι πήγε στραβά';

  @override
  String get statusRecognizing => 'Ανάγνωση κειμένου…';

  @override
  String get statusPreparingModel => 'Προετοιμασία μετάφρασης…';

  @override
  String get statusTranslating => 'Μετάφραση…';

  @override
  String get sourceLabel => 'Πρωτότυπο';

  @override
  String get translationLabel => 'Μετάφραση';

  @override
  String get retryButton => 'Δοκιμάστε ξανά';

  @override
  String get changeLanguageButton => 'Αλλαγή γλώσσας';

  @override
  String get historyLabel => 'Ιστορικό';

  @override
  String get defaultLanguageLabel => 'Προεπιλεγμένη γλώσσα μετάφρασης';

  @override
  String get aboutLabel => 'Σχετικά';

  @override
  String get licensesLabel => 'Άδειες ανοιχτού κώδικα';

  @override
  String get shareAppLabel => 'Κοινοποίηση εφαρμογής';

  @override
  String get versionLabel => 'Έκδοση';

  @override
  String get historyEmpty => 'Δεν υπάρχουν σαρώσεις ακόμη';

  @override
  String get historyClearConfirm => 'Διαγραφή όλου του ιστορικού;';

  @override
  String get termsLink => 'Όροι χρήσης';

  @override
  String get tagline => 'Στρέψτε την κάμερα σε οποιοδήποτε κείμενο και κατανοήστε το αμέσως.';

  @override
  String get noResults => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get copiedMessage => 'Αντιγράφηκε στο πρόχειρο';

  @override
  String get exportTxtAction => 'Εξαγωγή ως κείμενο';

  @override
  String get exportPdfAction => 'Εξαγωγή ως PDF';

  @override
  String get translatedTo => 'Μεταφράστηκε σε';

  @override
  String get translateToLabel => 'Μετάφραση σε';

  @override
  String get typeTextLabel => 'Πληκτρολογήστε ή επικολλήστε κείμενο';

  @override
  String get importFileLabel => 'Εισαγωγή αρχείου';

  @override
  String get recentScansLabel => 'Πρόσφατες σαρώσεις';

  @override
  String get seeAllLabel => 'Προβολή όλων';

  @override
  String get uiLanguageLabel => 'Γλώσσα εφαρμογής';

  @override
  String get historyToday => 'Σήμερα';

  @override
  String get historyYesterday => 'Χθες';

  @override
  String get historyOlder => 'Παλαιότερα';

  @override
  String get typeTextButtonLabel => 'Πληκτρολόγηση κειμένου';

  @override
  String get removeAdsSubtitle => 'Αγορά μία φορά';

  @override
  String get removeAdsShortLabel => 'Αφαίρεση';

  @override
  String get charactersLabel => 'χαρακτήρες';

  @override
  String get clearHistoryLabel => 'Διαγραφή όλου του ιστορικού';

  @override
  String get cameraLabel => 'Κάμερα';

  @override
  String get recentLanguagesLabel => 'Πρόσφατες';

  @override
  String get allLanguagesLabel => 'Όλες οι γλώσσες';

  @override
  String get noResultsSubtitle => 'Δοκιμάστε άλλη ορθογραφία.';

  @override
  String get sectionSystemLabel => 'Σύστημα';

  @override
  String get appLanguageLabel => 'Γλώσσα εφαρμογής';
}
