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
}
