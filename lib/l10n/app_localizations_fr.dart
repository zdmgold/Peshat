// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Scanner un document';

  @override
  String get resultTitle => 'Résultat';

  @override
  String get copyAction => 'Copier';

  @override
  String get shareAction => 'Partager';

  @override
  String get saveAction => 'Enregistrer';

  @override
  String get readyToScan => 'Prêt à scanner';

  @override
  String get selectLanguageTitle => 'Sélectionner la langue';

  @override
  String get searchLanguagesHint => 'Rechercher des langues...';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get adStatusLabel => 'État des annonces :';

  @override
  String get adsShownStatus => 'Annonces affichées';

  @override
  String get themeLabel => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeDark => 'Sombre';

  @override
  String get removeAdsButton => 'Supprimer les annonces';

  @override
  String get restorePurchaseButton => 'Restaurer l\'achat';

  @override
  String get privacyPolicyLink => 'Politique de confidentialité';

  @override
  String get supportLink => 'Assistance';

  @override
  String get adsRemovedBadge => 'Annonces supprimées';

  @override
  String get semanticsAppIcon => 'Icône de l\'application Peshat';

  @override
  String get semanticsScanButton => 'Bouton Scanner un document';

  @override
  String get semanticsSearchField => 'Rechercher des langues';

  @override
  String get semanticsRemoveAds => 'Supprimer les annonces';

  @override
  String get cameraUsageDescription => 'Peshat utilise l\'appareil photo pour scanner le texte et le traduire. Les images sont traitées sur l\'appareil et ne sont pas téléchargées.';

  @override
  String get trackingUsageDescription => 'Utilisé pour afficher des annonces non personnalisées pertinentes si vous refusez ; des annonces personnalisées si vous acceptez.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
