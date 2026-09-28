// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'סריקת מסמך';

  @override
  String get resultTitle => 'תוצאה';

  @override
  String get copyAction => 'העתק';

  @override
  String get shareAction => 'שתף';

  @override
  String get saveAction => 'שמור';

  @override
  String get readyToScan => 'מוכן לסריקה';

  @override
  String get selectLanguageTitle => 'בחר שפה';

  @override
  String get searchLanguagesHint => 'חפש שפות...';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get adStatusLabel => 'מצב מודעות:';

  @override
  String get adsShownStatus => 'מודעות מוצגות';

  @override
  String get themeLabel => 'ערכת נושא';

  @override
  String get themeLight => 'בהיר';

  @override
  String get themeSystem => 'מערכת';

  @override
  String get themeDark => 'כהה';

  @override
  String get removeAdsButton => 'הסר מודעות';

  @override
  String get restorePurchaseButton => 'שחזר רכישה';

  @override
  String get privacyPolicyLink => 'מדיניות פרטיות';

  @override
  String get supportLink => 'תמיכה';

  @override
  String get adsRemovedBadge => 'מודעות הוסרו';

  @override
  String get semanticsAppIcon => 'סמל אפליקציית Peshat';

  @override
  String get semanticsScanButton => 'כפתור סריקת מסמך';

  @override
  String get semanticsSearchField => 'חפש שפות';

  @override
  String get semanticsRemoveAds => 'הסר מודעות';

  @override
  String get cameraUsageDescription => 'Peshat משתמש במצלמה כדי לסרוק ולתרגם טקסט. התמונות מעובדות במכשיר ואינן מועלות.';

  @override
  String get trackingUsageDescription => 'משמש להצגת מודעות רלוונטיות לא מותאמות אישית אם תסרב; מודעות מותאמות אישית אם תסכים.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'לא נמצא טקסט בתמונה';

  @override
  String get errorImageUnreadable => 'לא ניתן לקרוא את התמונה';

  @override
  String get errorModelDownloadFailed => 'לא ניתן להוריד את מודל התרגום';

  @override
  String get errorUnsupportedLanguage => 'שפה זו עדיין לא נתמכת';

  @override
  String get errorOcrFailed => 'זיהוי הטקסט נכשל';

  @override
  String get errorTranslationFailed => 'התרגום נכשל';

  @override
  String get errorTimeout => 'הפעולה ארכה זמן רב מדי';

  @override
  String get errorUnknown => 'משהו השתבש';

  @override
  String get statusRecognizing => 'קורא טקסט…';

  @override
  String get statusPreparingModel => 'מכין תרגום…';

  @override
  String get statusTranslating => 'מתרגם…';

  @override
  String get sourceLabel => 'מקור';

  @override
  String get translationLabel => 'תרגום';

  @override
  String get retryButton => 'נסה שוב';

  @override
  String get changeLanguageButton => 'שנה שפה';

  @override
  String get historyLabel => 'היסטוריה';

  @override
  String get defaultLanguageLabel => 'שפת תרגום ברירת מחדל';

  @override
  String get aboutLabel => 'אודות';

  @override
  String get licensesLabel => 'רישיונות קוד פתוח';

  @override
  String get shareAppLabel => 'שתף אפליקציה זו';

  @override
  String get versionLabel => 'גרסה';
}
