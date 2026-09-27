// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Document scannen';

  @override
  String get resultTitle => 'Resultaat';

  @override
  String get copyAction => 'Kopiëren';

  @override
  String get shareAction => 'Delen';

  @override
  String get saveAction => 'Opslaan';

  @override
  String get readyToScan => 'Klaar om te scannen';

  @override
  String get selectLanguageTitle => 'Taal selecteren';

  @override
  String get searchLanguagesHint => 'Talen zoeken...';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get adStatusLabel => 'Advertentiestatus:';

  @override
  String get adsShownStatus => 'Advertenties weergegeven';

  @override
  String get themeLabel => 'Thema';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeDark => 'Donker';

  @override
  String get removeAdsButton => 'Advertenties verwijderen';

  @override
  String get restorePurchaseButton => 'Aankoop herstellen';

  @override
  String get privacyPolicyLink => 'Privacybeleid';

  @override
  String get supportLink => 'Ondersteuning';

  @override
  String get adsRemovedBadge => 'Advertenties verwijderd';

  @override
  String get semanticsAppIcon => 'Peshat app-pictogram';

  @override
  String get semanticsScanButton => 'Knop Document scannen';

  @override
  String get semanticsSearchField => 'Talen zoeken';

  @override
  String get semanticsRemoveAds => 'Advertenties verwijderen';

  @override
  String get cameraUsageDescription => 'Peshat gebruikt de camera om tekst te scannen en te vertalen. Afbeeldingen worden op het apparaat verwerkt en niet geüpload.';

  @override
  String get trackingUsageDescription => 'Wordt gebruikt om relevante, niet-gepersonaliseerde advertenties weer te geven als u weigert; gepersonaliseerde advertenties als u toestemt.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
