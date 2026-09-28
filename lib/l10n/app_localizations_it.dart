// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Scansiona documento';

  @override
  String get resultTitle => 'Risultato';

  @override
  String get copyAction => 'Copia';

  @override
  String get shareAction => 'Condividi';

  @override
  String get saveAction => 'Salva';

  @override
  String get readyToScan => 'Pronto per la scansione';

  @override
  String get selectLanguageTitle => 'Seleziona lingua';

  @override
  String get searchLanguagesHint => 'Cerca lingue...';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get adStatusLabel => 'Stato annunci:';

  @override
  String get adsShownStatus => 'Annunci attivi';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Scuro';

  @override
  String get removeAdsButton => 'Rimuovi annunci';

  @override
  String get restorePurchaseButton => 'Ripristina acquisto';

  @override
  String get privacyPolicyLink => 'Informativa sulla privacy';

  @override
  String get supportLink => 'Supporto';

  @override
  String get adsRemovedBadge => 'Annunci rimossi';

  @override
  String get semanticsAppIcon => 'Icona dell\'app Peshat';

  @override
  String get semanticsScanButton => 'Pulsante Scansiona documento';

  @override
  String get semanticsSearchField => 'Cerca lingue';

  @override
  String get semanticsRemoveAds => 'Rimuovi annunci';

  @override
  String get cameraUsageDescription => 'Peshat utilizza la fotocamera per scansionare e tradurre il testo. Le immagini vengono elaborate sul dispositivo e non vengono caricate.';

  @override
  String get trackingUsageDescription => 'Utilizzato per mostrare annunci non personalizzati pertinenti se rifiuti; annunci personalizzati se acconsenti.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Nessun testo trovato nell’immagine';

  @override
  String get errorImageUnreadable => 'Impossibile leggere l’immagine';

  @override
  String get errorModelDownloadFailed => 'Impossibile scaricare il modello di traduzione';

  @override
  String get errorUnsupportedLanguage => 'Questa lingua non è ancora supportata';

  @override
  String get errorOcrFailed => 'Riconoscimento del testo non riuscito';

  @override
  String get errorTranslationFailed => 'Traduzione non riuscita';

  @override
  String get errorTimeout => 'L’operazione ha impiegato troppo tempo';

  @override
  String get errorUnknown => 'Qualcosa è andato storto';

  @override
  String get statusRecognizing => 'Lettura del testo…';

  @override
  String get statusPreparingModel => 'Preparazione della traduzione…';

  @override
  String get statusTranslating => 'Traduzione…';

  @override
  String get sourceLabel => 'Originale';

  @override
  String get translationLabel => 'Traduzione';

  @override
  String get retryButton => 'Riprova';

  @override
  String get changeLanguageButton => 'Cambia lingua';

  @override
  String get historyLabel => 'Cronologia';

  @override
  String get defaultLanguageLabel => 'Lingua di traduzione predefinita';

  @override
  String get aboutLabel => 'Informazioni';

  @override
  String get licensesLabel => 'Licenze open source';

  @override
  String get shareAppLabel => 'Condividi questa app';

  @override
  String get versionLabel => 'Versione';

  @override
  String get historyEmpty => 'Nessuna scansione ancora';

  @override
  String get historyClearConfirm => 'Eliminare tutta la cronologia?';

  @override
  String get termsLink => 'Termini di servizio';

  @override
  String get tagline => 'Inquadra un testo con la fotocamera e capiscilo subito.';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get copiedMessage => 'Copiato negli appunti';

  @override
  String get exportTxtAction => 'Esporta come testo';

  @override
  String get exportPdfAction => 'Esporta come PDF';

  @override
  String get translatedTo => 'Tradotto in';

  @override
  String get translateToLabel => 'Traduci in';

  @override
  String get typeTextLabel => 'Digita o incolla il testo';

  @override
  String get importFileLabel => 'Importa un file';

  @override
  String get recentScansLabel => 'Scansioni recenti';

  @override
  String get seeAllLabel => 'Vedi tutto';

  @override
  String get uiLanguageLabel => 'Lingua dell’app';

  @override
  String get historyToday => 'Oggi';

  @override
  String get historyYesterday => 'Ieri';

  @override
  String get historyOlder => 'Più vecchio';

  @override
  String get typeTextButtonLabel => 'Digita testo';

  @override
  String get removeAdsSubtitle => 'Acquisto singolo';

  @override
  String get removeAdsShortLabel => 'Rimuovi';

  @override
  String get charactersLabel => 'caratteri';

  @override
  String get clearHistoryLabel => 'Cancella tutta la cronologia';

  @override
  String get cameraLabel => 'Fotocamera';

  @override
  String get recentLanguagesLabel => 'Recenti';

  @override
  String get allLanguagesLabel => 'Tutte le lingue';

  @override
  String get noResultsSubtitle => 'Prova con un’ortografia diversa.';

  @override
  String get sectionSystemLabel => 'Sistema';

  @override
  String get appLanguageLabel => 'Lingua dell’app';

  @override
  String get clearTextConfirm => 'Cancellare il testo?';

  @override
  String get historyEmptySubtitle => 'Le scansioni tradotte appariranno qui.';
}
