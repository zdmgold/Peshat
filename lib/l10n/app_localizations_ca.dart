// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Escaneja un document';

  @override
  String get resultTitle => 'Resultat';

  @override
  String get copyAction => 'Copia';

  @override
  String get shareAction => 'Comparteix';

  @override
  String get saveAction => 'Desa';

  @override
  String get readyToScan => 'A punt per escanejar';

  @override
  String get selectLanguageTitle => 'Selecciona un idioma';

  @override
  String get searchLanguagesHint => 'Cerca idiomes...';

  @override
  String get settingsTitle => 'Configuració';

  @override
  String get adStatusLabel => 'Estat dels anuncis';

  @override
  String get adsShownStatus => 'Anuncis visibles';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Clar';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Fosc';

  @override
  String get removeAdsButton => 'Elimina els anuncis';

  @override
  String get restorePurchaseButton => 'Restaura la compra';

  @override
  String get privacyPolicyLink => 'Política de privadesa';

  @override
  String get supportLink => 'Assistència';

  @override
  String get adsRemovedBadge => 'Anuncis eliminats';

  @override
  String get semanticsAppIcon => 'Icona de l\'aplicació Peshat';

  @override
  String get semanticsScanButton => 'Botó d\'escaneig de document';

  @override
  String get semanticsSearchField => 'Cerca idiomes';

  @override
  String get semanticsRemoveAds => 'Elimina els anuncis';

  @override
  String get cameraUsageDescription => 'Peshat utilitza la càmera per escanejar text i traduir-lo. Les imatges es processen al dispositiu i no es pugen enlloc.';

  @override
  String get trackingUsageDescription => 'S\'utilitza per mostrar anuncis rellevants no personalitzats si ho rebutges, i anuncis personalitzats si ho permets.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'No s\'ha trobat cap text a la imatge';

  @override
  String get errorImageUnreadable => 'No s\'ha pogut llegir la imatge';

  @override
  String get errorModelDownloadFailed => 'No s\'ha pogut rebre el paquet d\'idioma. Comprova la connexió a internet i torna-ho a provar.';

  @override
  String get errorUnsupportedLanguage => 'Aquest idioma encara no és compatible';

  @override
  String get errorOcrFailed => 'El reconeixement de text ha fallat';

  @override
  String get errorTranslationFailed => 'La traducció ha fallat';

  @override
  String get errorTimeout => 'L\'operació ha trigat massa';

  @override
  String get errorUnknown => 'Alguna cosa ha anat malament';

  @override
  String get statusRecognizing => 'S\'està llegint el text…';

  @override
  String get statusPreparingModel => 'S\'està preparant la traducció…';

  @override
  String get statusTranslating => 'S\'està traduint…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Traducció';

  @override
  String get retryButton => 'Torna-ho a provar';

  @override
  String get changeLanguageButton => 'Canvia l\'idioma';

  @override
  String get historyLabel => 'Historial';

  @override
  String get defaultLanguageLabel => 'Idioma de traducció predeterminat';

  @override
  String get aboutLabel => 'Quant a';

  @override
  String get licensesLabel => 'Llicències de codi obert';

  @override
  String get shareAppLabel => 'Comparteix aquesta aplicació';

  @override
  String get versionLabel => 'Versió';

  @override
  String get historyEmpty => 'Encara no hi ha cap escaneig';

  @override
  String get historyClearConfirm => 'Vols suprimir tot l\'historial?';

  @override
  String get termsLink => 'Condicions del servei';

  @override
  String get tagline => 'Apunta la càmera a qualsevol text i entén-lo a l\'instant.';

  @override
  String get noResults => 'Sense resultats';

  @override
  String get copiedMessage => 'S\'ha copiat al porta-retalls';

  @override
  String get exportTxtAction => 'Exporta com a text';

  @override
  String get exportPdfAction => 'Exporta com a PDF';

  @override
  String get translatedTo => 'Traduït a';

  @override
  String get translatedFrom => 'Traduït des de';

  @override
  String get scanLatinHint => 'Per a la traducció més precisa, feu servir Escriu text. L\'escaneig i la importació funcionen millor amb text clar en alfabet llatí.';

  @override
  String get translateToLabel => 'Tradueix a';

  @override
  String get typeTextLabel => 'Escriu o enganxa text';

  @override
  String get importFileLabel => 'Importa un fitxer';

  @override
  String get recentScansLabel => 'Escaneigs recents';

  @override
  String get seeAllLabel => 'Mostra-ho tot';

  @override
  String get uiLanguageLabel => 'Idioma de l\'aplicació';

  @override
  String get historyToday => 'Avui';

  @override
  String get historyYesterday => 'Ahir';

  @override
  String get historyOlder => 'Més antics';

  @override
  String get typeTextButtonLabel => 'Escriu text';

  @override
  String get removeAdsSubtitle => 'Compra única';

  @override
  String get removeAdsShortLabel => 'Elimina';

  @override
  String get charactersLabel => 'caràcters';

  @override
  String get clearHistoryLabel => 'Esborra tot l\'historial';

  @override
  String get cameraLabel => 'Càmera';

  @override
  String get recentLanguagesLabel => 'Recents';

  @override
  String get allLanguagesLabel => 'Tots els idiomes';

  @override
  String get noResultsSubtitle => 'Prova una ortografia diferent.';

  @override
  String get sectionSystemLabel => 'Sistema';

  @override
  String get appLanguageLabel => 'Idioma de l\'aplicació';

  @override
  String get clearTextConfirm => 'Vols esborrar el text?';

  @override
  String get historyEmptySubtitle => 'Els escaneigs que tradueixis apareixeran aquí.';

  @override
  String get cancelButtonLabel => 'Cancel·la';

  @override
  String get okButtonLabel => 'D\'acord';

  @override
  String get closeButtonTooltip => 'Tanca';

  @override
  String get showMenuTooltip => 'Mostra el menú';

  @override
  String get licensePackageLabel => 'Paquet';

  @override
  String get licenseEmptyLabel => 'No hi ha informació de llicència disponible.';

  @override
  String get rateAppLabel => 'Valora Peshat';

  @override
  String get notificationsSectionLabel => 'Notificacions';

  @override
  String get reminderNotificationsLabel => 'Recordatoris';

  @override
  String get reminderNotificationsSubtitle => 'Rep un recordatori si fa uns quants dies que no uses Peshat.';

  @override
  String get reminderNotificationTitle => 'Continua les teves traduccions';

  @override
  String get reminderNotificationBody => 'Reprèn amb Peshat on ho havies deixat.';

  @override
  String get notificationPermissionDenied => 'Activa les notificacions a la configuració del sistema per rebre recordatoris.';

  @override
  String get scanShortLabel => 'Escaneja';

  @override
  String get recentLabel => 'Recents';

  @override
  String get purchaseUnavailable => 'Les compres no estan disponibles ara mateix. Torna-ho a provar més tard.';

  @override
  String get restoreChecking => 'S\'estan comprovant les compres anteriors…';

  @override
  String get adPrivacyChoices => 'Opcions de privadesa dels anuncis';

  @override
  String get followSystemLabel => 'Segueix el sistema';

  @override
  String get couldNotOpenLink => 'No s\'ha pogut obrir l\'enllaç';

  @override
  String get pdfFontDownloading => 'S\'està rebent el tipus de lletra d\'aquest PDF…';

  @override
  String get pdfFontDownloadFailed => 'No s\'ha pogut rebre el tipus de lletra d\'aquest PDF. Comprova la connexió a internet i torna-ho a provar.';

  @override
  String get packReceivingTitle => 'S\'està rebent el paquet d\'idioma…';

  @override
  String get packReceivedTitle => 'Paquet rebut';

  @override
  String get errorOfflinePackNeeded => 'No hi ha connexió a internet. Aquest idioma necessita rebre un paquet una sola vegada. Connecta\'t a internet i torna-ho a provar.';

  @override
  String get errorPackTooSlow => 'El paquet d\'idioma triga massa a rebre\'s. Pot ser que la connexió a internet sigui feble. Torna-ho a provar.';

  @override
  String get errorNoTextHint => 'Per a la traducció més precisa, feu servir Escriu text. L\'escaneig i la importació funcionen millor amb text clar en alfabet llatí.';
}
