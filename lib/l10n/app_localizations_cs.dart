// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Skenovat dokument';

  @override
  String get resultTitle => 'Výsledek';

  @override
  String get copyAction => 'Kopírovat';

  @override
  String get shareAction => 'Sdílet';

  @override
  String get saveAction => 'Uložit';

  @override
  String get readyToScan => 'Připraveno ke skenování';

  @override
  String get selectLanguageTitle => 'Vybrat jazyk';

  @override
  String get searchLanguagesHint => 'Hledat jazyky...';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get adStatusLabel => 'Stav reklam:';

  @override
  String get adsShownStatus => 'Reklamy se zobrazují';

  @override
  String get themeLabel => 'Motiv';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeSystem => 'Systém';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get removeAdsButton => 'Odstranit reklamy';

  @override
  String get restorePurchaseButton => 'Obnovit nákup';

  @override
  String get privacyPolicyLink => 'Zásady ochrany osobních údajů';

  @override
  String get supportLink => 'Podpora';

  @override
  String get adsRemovedBadge => 'Reklamy odstraněny';

  @override
  String get semanticsAppIcon => 'Ikona aplikace Peshat';

  @override
  String get semanticsScanButton => 'Tlačítko Skenovat dokument';

  @override
  String get semanticsSearchField => 'Hledat jazyky';

  @override
  String get semanticsRemoveAds => 'Odstranit reklamy';

  @override
  String get cameraUsageDescription => 'Peshat používá fotoaparát ke skenování a překladu textu. Obrázky jsou zpracovávány na zařízení a nejsou nahrávány.';

  @override
  String get trackingUsageDescription => 'Používá se k zobrazení relevantních, nepersonalizovaných reklam, pokud odmítnete; personalizovaných reklam, pokud souhlasíte.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'V obrázku nebyl nalezen žádný text';

  @override
  String get errorImageUnreadable => 'Obrázek nelze přečíst';

  @override
  String get errorModelDownloadFailed => 'Model překladu nelze stáhnout';

  @override
  String get errorUnsupportedLanguage => 'Tento jazyk zatím není podporován';

  @override
  String get errorOcrFailed => 'Rozpoznání textu selhalo';

  @override
  String get errorTranslationFailed => 'Překlad selhal';

  @override
  String get errorTimeout => 'Operace trvala příliš dlouho';

  @override
  String get errorUnknown => 'Něco se pokazilo';

  @override
  String get statusRecognizing => 'Čtení textu…';

  @override
  String get statusPreparingModel => 'Příprava překladu…';

  @override
  String get statusTranslating => 'Překládání…';

  @override
  String get sourceLabel => 'Originál';

  @override
  String get translationLabel => 'Překlad';

  @override
  String get retryButton => 'Zkusit znovu';

  @override
  String get changeLanguageButton => 'Změnit jazyk';

  @override
  String get historyLabel => 'Historie';

  @override
  String get defaultLanguageLabel => 'Výchozí jazyk překladu';

  @override
  String get aboutLabel => 'O aplikaci';

  @override
  String get licensesLabel => 'Licence open source';

  @override
  String get shareAppLabel => 'Sdílet tuto aplikaci';

  @override
  String get versionLabel => 'Verze';
}
