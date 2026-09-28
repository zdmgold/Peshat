// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Dokumentum beolvasása';

  @override
  String get resultTitle => 'Eredmény';

  @override
  String get copyAction => 'Másolás';

  @override
  String get shareAction => 'Megosztás';

  @override
  String get saveAction => 'Mentés';

  @override
  String get readyToScan => 'Készen áll a beolvasásra';

  @override
  String get selectLanguageTitle => 'Nyelv kiválasztása';

  @override
  String get searchLanguagesHint => 'Nyelvek keresése...';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get adStatusLabel => 'Hirdetések állapota:';

  @override
  String get adsShownStatus => 'Hirdetések megjelennek';

  @override
  String get themeLabel => 'Téma';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeDark => 'Sötét';

  @override
  String get removeAdsButton => 'Hirdetések eltávolítása';

  @override
  String get restorePurchaseButton => 'Vásárlás visszaállítása';

  @override
  String get privacyPolicyLink => 'Adatvédelmi irányelvek';

  @override
  String get supportLink => 'Támogatás';

  @override
  String get adsRemovedBadge => 'Hirdetések eltávolítva';

  @override
  String get semanticsAppIcon => 'Peshat alkalmazás ikonja';

  @override
  String get semanticsScanButton => 'Dokumentum beolvasása gomb';

  @override
  String get semanticsSearchField => 'Nyelvek keresése';

  @override
  String get semanticsRemoveAds => 'Hirdetések eltávolítása';

  @override
  String get cameraUsageDescription => 'A Peshat a kamerát használja a szöveg beolvasására és lefordítására. A képek az eszközön kerülnek feldolgozásra, és nem kerülnek feltöltésre.';

  @override
  String get trackingUsageDescription => 'Arra szolgál, hogy releváns, nem személyre szabott hirdetéseket jelenítsen meg, ha elutasítja; személyre szabott hirdetéseket, ha beleegyezik.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Nem található szöveg a képen';

  @override
  String get errorImageUnreadable => 'A kép nem olvasható';

  @override
  String get errorModelDownloadFailed => 'A fordítási modellt nem sikerült letölteni';

  @override
  String get errorUnsupportedLanguage => 'Ez a nyelv még nem támogatott';

  @override
  String get errorOcrFailed => 'A szövegfelismerés sikertelen';

  @override
  String get errorTranslationFailed => 'A fordítás sikertelen';

  @override
  String get errorTimeout => 'A művelet túl sokáig tartott';

  @override
  String get errorUnknown => 'Valami hiba történt';

  @override
  String get statusRecognizing => 'Szöveg olvasása…';

  @override
  String get statusPreparingModel => 'Fordítás előkészítése…';

  @override
  String get statusTranslating => 'Fordítás…';

  @override
  String get sourceLabel => 'Eredeti';

  @override
  String get translationLabel => 'Fordítás';

  @override
  String get retryButton => 'Újra';

  @override
  String get changeLanguageButton => 'Nyelv módosítása';

  @override
  String get historyLabel => 'Előzmények';

  @override
  String get defaultLanguageLabel => 'Alapértelmezett fordítási nyelv';

  @override
  String get aboutLabel => 'Névjegy';

  @override
  String get licensesLabel => 'Nyílt forráskódú licencek';

  @override
  String get shareAppLabel => 'Alkalmazás megosztása';

  @override
  String get versionLabel => 'Verzió';

  @override
  String get historyEmpty => 'Még nincsenek beolvasások';

  @override
  String get historyClearConfirm => 'Törli a teljes előzményt?';

  @override
  String get termsLink => 'Szolgáltatási feltételek';

  @override
  String get tagline => 'Irányítsa a kamerát bármilyen szövegre, és azonnal értse meg.';

  @override
  String get noResults => 'Nincs találat';

  @override
  String get copiedMessage => 'Vágólapra másolva';

  @override
  String get exportTxtAction => 'Exportálás szövegként';

  @override
  String get exportPdfAction => 'Exportálás PDF-ként';

  @override
  String get translatedTo => 'Lefordítva';

  @override
  String get translateToLabel => 'Fordítás erre';

  @override
  String get typeTextLabel => 'Írjon be vagy illesszen be szöveget';

  @override
  String get importFileLabel => 'Fájl importálása';

  @override
  String get recentScansLabel => 'Legutóbbi beolvasások';

  @override
  String get seeAllLabel => 'Összes megtekintése';

  @override
  String get uiLanguageLabel => 'Alkalmazás nyelve';

  @override
  String get historyToday => 'Ma';

  @override
  String get historyYesterday => 'Tegnap';

  @override
  String get historyOlder => 'Régebbi';

  @override
  String get typeTextButtonLabel => 'Szöveg beírása';
}
