// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Dokument scannen';

  @override
  String get resultTitle => 'Ergebnis';

  @override
  String get copyAction => 'Kopieren';

  @override
  String get shareAction => 'Teilen';

  @override
  String get saveAction => 'Speichern';

  @override
  String get readyToScan => 'Bereit zum Scannen';

  @override
  String get selectLanguageTitle => 'Sprache auswählen';

  @override
  String get searchLanguagesHint => 'Sprachen suchen...';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get adStatusLabel => 'Werbestatus:';

  @override
  String get adsShownStatus => 'Werbung aktiv';

  @override
  String get themeLabel => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get removeAdsButton => 'Werbung entfernen';

  @override
  String get restorePurchaseButton => 'Kauf wiederherstellen';

  @override
  String get privacyPolicyLink => 'Datenschutzrichtlinie';

  @override
  String get supportLink => 'Support';

  @override
  String get adsRemovedBadge => 'Werbung entfernt';

  @override
  String get semanticsAppIcon => 'Peshat App-Symbol';

  @override
  String get semanticsScanButton => 'Dokument scannen Schaltfläche';

  @override
  String get semanticsSearchField => 'Sprachen suchen';

  @override
  String get semanticsRemoveAds => 'Werbung entfernen';

  @override
  String get cameraUsageDescription => 'Peshat verwendet die Kamera, um Text zu scannen und zu übersetzen. Bilder werden auf dem Gerät verarbeitet und nicht hochgeladen.';

  @override
  String get trackingUsageDescription => 'Wird verwendet, um relevante, nicht personalisierte Anzeigen anzuzeigen, wenn Sie ablehnen; personalisierte Anzeigen, wenn Sie zustimmen.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Kein Text im Bild gefunden';

  @override
  String get errorImageUnreadable => 'Das Bild konnte nicht gelesen werden';

  @override
  String get errorModelDownloadFailed => 'Übersetzungsmodell konnte nicht heruntergeladen werden';

  @override
  String get errorUnsupportedLanguage => 'Diese Sprache wird noch nicht unterstützt';

  @override
  String get errorOcrFailed => 'Texterkennung fehlgeschlagen';

  @override
  String get errorTranslationFailed => 'Übersetzung fehlgeschlagen';

  @override
  String get errorTimeout => 'Der Vorgang hat zu lange gedauert';

  @override
  String get errorUnknown => 'Etwas ist schiefgelaufen';

  @override
  String get statusRecognizing => 'Text wird gelesen…';

  @override
  String get statusPreparingModel => 'Übersetzung wird vorbereitet…';

  @override
  String get statusTranslating => 'Übersetze…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Übersetzung';

  @override
  String get retryButton => 'Erneut versuchen';

  @override
  String get changeLanguageButton => 'Sprache ändern';

  @override
  String get historyLabel => 'Verlauf';

  @override
  String get defaultLanguageLabel => 'Standard-Übersetzungssprache';

  @override
  String get aboutLabel => 'Über';

  @override
  String get licensesLabel => 'Open-Source-Lizenzen';

  @override
  String get shareAppLabel => 'Diese App teilen';

  @override
  String get versionLabel => 'Version';

  @override
  String get historyEmpty => 'Noch keine Scans';

  @override
  String get historyClearConfirm => 'Gesamten Verlauf löschen?';

  @override
  String get termsLink => 'Nutzungsbedingungen';

  @override
  String get tagline => 'Richte deine Kamera auf einen beliebigen Text und verstehe ihn sofort.';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get copiedMessage => 'In die Zwischenablage kopiert';

  @override
  String get exportTxtAction => 'Als Text exportieren';

  @override
  String get exportPdfAction => 'Als PDF exportieren';

  @override
  String get translatedTo => 'Übersetzt nach';
}
