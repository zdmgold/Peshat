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

  @override
  String get errorNoTextDetected => 'Aucun texte trouvé dans l’image';

  @override
  String get errorImageUnreadable => 'L’image n’a pas pu être lue';

  @override
  String get errorModelDownloadFailed => 'Impossible de télécharger le modèle de traduction';

  @override
  String get errorUnsupportedLanguage => 'Cette langue n’est pas encore prise en charge';

  @override
  String get errorOcrFailed => 'Échec de la reconnaissance de texte';

  @override
  String get errorTranslationFailed => 'Échec de la traduction';

  @override
  String get errorTimeout => 'L’opération a pris trop de temps';

  @override
  String get errorUnknown => 'Une erreur est survenue';

  @override
  String get statusRecognizing => 'Lecture du texte…';

  @override
  String get statusPreparingModel => 'Préparation de la traduction…';

  @override
  String get statusTranslating => 'Traduction…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Traduction';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get changeLanguageButton => 'Changer de langue';

  @override
  String get historyLabel => 'Historique';

  @override
  String get defaultLanguageLabel => 'Langue de traduction par défaut';

  @override
  String get aboutLabel => 'À propos';

  @override
  String get licensesLabel => 'Licences open source';

  @override
  String get shareAppLabel => 'Partager cette application';

  @override
  String get versionLabel => 'Version';

  @override
  String get historyEmpty => 'Aucun scan pour le moment';

  @override
  String get historyClearConfirm => 'Supprimer tout l’historique ?';

  @override
  String get termsLink => 'Conditions d’utilisation';

  @override
  String get tagline => 'Pointez votre appareil photo vers un texte et comprenez-le instantanément.';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get copiedMessage => 'Copié dans le presse-papiers';

  @override
  String get exportTxtAction => 'Exporter en texte';

  @override
  String get exportPdfAction => 'Exporter en PDF';

  @override
  String get translatedTo => 'Traduit en';

  @override
  String get translateToLabel => 'Traduire en';

  @override
  String get typeTextLabel => 'Saisir ou coller du texte';

  @override
  String get importFileLabel => 'Importer un fichier';

  @override
  String get recentScansLabel => 'Analyses récentes';

  @override
  String get seeAllLabel => 'Voir tout';

  @override
  String get uiLanguageLabel => 'Langue de l’application';

  @override
  String get historyToday => 'Aujourd’hui';

  @override
  String get historyYesterday => 'Hier';

  @override
  String get historyOlder => 'Plus ancien';

  @override
  String get typeTextButtonLabel => 'Saisir du texte';

  @override
  String get removeAdsSubtitle => 'Achat unique';

  @override
  String get removeAdsShortLabel => 'Retirer';

  @override
  String get charactersLabel => 'caractères';

  @override
  String get clearHistoryLabel => 'Effacer tout l’historique';

  @override
  String get cameraLabel => 'Appareil photo';

  @override
  String get recentLanguagesLabel => 'Récentes';

  @override
  String get allLanguagesLabel => 'Toutes les langues';

  @override
  String get noResultsSubtitle => 'Essayez une autre orthographe.';

  @override
  String get sectionSystemLabel => 'Système';

  @override
  String get appLanguageLabel => 'Langue de l’application';

  @override
  String get clearTextConfirm => 'Effacer le texte ?';

  @override
  String get historyEmptySubtitle => 'Les scans que vous traduisez apparaîtront ici.';

  @override
  String get cancelButtonLabel => 'Annuler';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Fermer';

  @override
  String get showMenuTooltip => 'Afficher le menu';

  @override
  String get licensePackageLabel => 'Paquet';

  @override
  String get licenseEmptyLabel => 'Aucune information de licence disponible.';

  @override
  String get rateAppLabel => 'Noter Peshat';

  @override
  String get notificationsSectionLabel => 'Notifications';

  @override
  String get reminderNotificationsLabel => 'Rappels';

  @override
  String get reminderNotificationsSubtitle => 'Recevez un rappel si vous n\'avez pas utilisé Peshat depuis quelques jours.';

  @override
  String get reminderNotificationTitle => 'Poursuivez vos traductions';

  @override
  String get reminderNotificationBody => 'Reprenez là où vous vous êtes arrêté avec Peshat.';

  @override
  String get notificationPermissionDenied => 'Activez les notifications dans les réglages système pour recevoir des rappels.';
}
