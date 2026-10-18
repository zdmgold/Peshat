// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Changanua Hati';

  @override
  String get resultTitle => 'Matokeo';

  @override
  String get copyAction => 'Nakili';

  @override
  String get shareAction => 'Shiriki';

  @override
  String get saveAction => 'Hifadhi';

  @override
  String get readyToScan => 'Tayari kuchanganua';

  @override
  String get selectLanguageTitle => 'Chagua Lugha';

  @override
  String get searchLanguagesHint => 'Tafuta lugha...';

  @override
  String get settingsTitle => 'Mipangilio';

  @override
  String get adStatusLabel => 'Hali ya Matangazo';

  @override
  String get adsShownStatus => 'Matangazo Yanaonyeshwa';

  @override
  String get themeLabel => 'Mandhari';

  @override
  String get themeLight => 'Mwangaza';

  @override
  String get themeSystem => 'Mfumo';

  @override
  String get themeDark => 'Giza';

  @override
  String get removeAdsButton => 'Ondoa Matangazo';

  @override
  String get restorePurchaseButton => 'Rejesha Ununuzi';

  @override
  String get privacyPolicyLink => 'Sera ya Faragha';

  @override
  String get supportLink => 'Usaidizi';

  @override
  String get adsRemovedBadge => 'Matangazo Yameondolewa';

  @override
  String get semanticsAppIcon => 'Aikoni ya Programu ya Peshat';

  @override
  String get semanticsScanButton => 'Kitufe cha Kuchanganua Hati';

  @override
  String get semanticsSearchField => 'Tafuta lugha';

  @override
  String get semanticsRemoveAds => 'Ondoa Matangazo';

  @override
  String get cameraUsageDescription => 'Peshat hutumia kamera kuchanganua maandishi kwa ajili ya tafsiri. Picha huchakatwa kwenye kifaa na hazipakiwi.';

  @override
  String get trackingUsageDescription => 'Hutumika kuonyesha matangazo yanayofaa yasiyobinafsishwa ukikataa, na matangazo yaliyobinafsishwa ukikubali.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Hakuna maandishi yaliyopatikana kwenye picha';

  @override
  String get errorImageUnreadable => 'Picha haikuweza kusomwa';

  @override
  String get errorModelDownloadFailed => 'Kifurushi cha lugha hakikuweza kupokelewa. Angalia muunganisho wako wa intaneti kisha ujaribu tena.';

  @override
  String get errorUnsupportedLanguage => 'Lugha hii bado haitumiki';

  @override
  String get errorOcrFailed => 'Utambuzi wa maandishi umeshindwa';

  @override
  String get errorTranslationFailed => 'Tafsiri imeshindwa';

  @override
  String get errorTimeout => 'Operesheni ilichukua muda mrefu sana';

  @override
  String get errorUnknown => 'Hitilafu fulani imetokea';

  @override
  String get statusRecognizing => 'Inasoma maandishi…';

  @override
  String get statusPreparingModel => 'Inaandaa tafsiri…';

  @override
  String get statusTranslating => 'Inatafsiri…';

  @override
  String get sourceLabel => 'Asili';

  @override
  String get translationLabel => 'Tafsiri';

  @override
  String get retryButton => 'Jaribu tena';

  @override
  String get changeLanguageButton => 'Badilisha lugha';

  @override
  String get historyLabel => 'Historia';

  @override
  String get defaultLanguageLabel => 'Lugha chaguomsingi ya tafsiri';

  @override
  String get aboutLabel => 'Kuhusu';

  @override
  String get licensesLabel => 'Leseni za chanzo huria';

  @override
  String get shareAppLabel => 'Shiriki programu hii';

  @override
  String get versionLabel => 'Toleo';

  @override
  String get historyEmpty => 'Hakuna uchanganuzi bado';

  @override
  String get historyClearConfirm => 'Futa historia yote?';

  @override
  String get termsLink => 'Masharti ya Huduma';

  @override
  String get tagline => 'Elekeza kamera yako kwenye maandishi yoyote, yaelewe papo hapo.';

  @override
  String get noResults => 'Hakuna matokeo';

  @override
  String get copiedMessage => 'Imenakiliwa kwenye ubao wa kunakili';

  @override
  String get exportTxtAction => 'Hamisha kama maandishi';

  @override
  String get exportPdfAction => 'Hamisha kama PDF';

  @override
  String get translatedTo => 'Imetafsiriwa kwa';

  @override
  String get translatedFrom => 'Imetafsiriwa kutoka';

  @override
  String get scanLatinHint => 'Kwa tafsiri sahihi zaidi, tumia Andika maandishi. Changanua na Leta hufanya kazi vizuri zaidi na maandishi wazi ya herufi za Kilatini.';

  @override
  String get sourceLanguageLabel => 'Lugha chanzo';

  @override
  String get destinationLanguageLabel => 'Lugha lengwa';

  @override
  String get languageAuto => 'Otomatiki';

  @override
  String get languageAutoLatin => 'Otomatiki (herufi za Kilatini)';

  @override
  String get pickerCameraReads => 'Kamera inaweza kusoma';

  @override
  String get pickerTypeOnly => 'Andika au bandika tu';

  @override
  String get cameraCannotReadLanguage => 'Kamera haiwezi kusoma lugha hii. Tumia Andika maandishi badala yake.';

  @override
  String get scanResultNote => 'Maandishi yaliyochanganuliwa yanaweza kuwa na makosa. Kwa tafsiri sahihi zaidi, tumia Andika maandishi.';

  @override
  String get translateToLabel => 'Tafsiri kwa';

  @override
  String get typeTextLabel => 'Andika au bandika maandishi';

  @override
  String get importFileLabel => 'Leta faili';

  @override
  String get recentScansLabel => 'Uchanganuzi wa hivi karibuni';

  @override
  String get seeAllLabel => 'Tazama zote';

  @override
  String get uiLanguageLabel => 'Lugha ya programu';

  @override
  String get historyToday => 'Leo';

  @override
  String get historyYesterday => 'Jana';

  @override
  String get historyOlder => 'Za zamani zaidi';

  @override
  String get typeTextButtonLabel => 'Andika maandishi';

  @override
  String get removeAdsSubtitle => 'Ununuzi wa mara moja';

  @override
  String get removeAdsShortLabel => 'Ondoa';

  @override
  String get charactersLabel => 'herufi';

  @override
  String get clearHistoryLabel => 'Futa historia yote';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get recentLanguagesLabel => 'Za hivi karibuni';

  @override
  String get allLanguagesLabel => 'Lugha zote';

  @override
  String get noResultsSubtitle => 'Jaribu tahajia tofauti.';

  @override
  String get sectionSystemLabel => 'Mfumo';

  @override
  String get appLanguageLabel => 'Lugha ya programu';

  @override
  String get clearTextConfirm => 'Futa maandishi?';

  @override
  String get historyEmptySubtitle => 'Uchanganuzi unaotafsiri utaonekana hapa.';

  @override
  String get cancelButtonLabel => 'Ghairi';

  @override
  String get okButtonLabel => 'Sawa';

  @override
  String get closeButtonTooltip => 'Funga';

  @override
  String get showMenuTooltip => 'Onyesha menyu';

  @override
  String get licensePackageLabel => 'Kifurushi';

  @override
  String get licenseEmptyLabel => 'Hakuna taarifa ya leseni inayopatikana.';

  @override
  String get rateAppLabel => 'Kadiria Peshat';

  @override
  String get notificationsSectionLabel => 'Arifa';

  @override
  String get reminderNotificationsLabel => 'Vikumbusho';

  @override
  String get reminderNotificationsSubtitle => 'Pata kikumbusho ikiwa hujatumia Peshat kwa siku chache.';

  @override
  String get reminderNotificationTitle => 'Endelea na tafsiri zako';

  @override
  String get reminderNotificationBody => 'Endelea ulipoishia na Peshat.';

  @override
  String get notificationPermissionDenied => 'Washa arifa kwenye mipangilio ya mfumo ili upokee vikumbusho.';

  @override
  String get scanShortLabel => 'Changanua';

  @override
  String get recentLabel => 'Za hivi karibuni';

  @override
  String get purchaseUnavailable => 'Ununuzi haupatikani kwa sasa. Tafadhali jaribu tena baadaye.';

  @override
  String get restoreChecking => 'Inakagua ununuzi wa awali…';

  @override
  String get adPrivacyChoices => 'Chaguo za faragha ya matangazo';

  @override
  String get followSystemLabel => 'Fuata mfumo';

  @override
  String get couldNotOpenLink => 'Kiungo hakikuweza kufunguliwa';

  @override
  String get pdfFontDownloading => 'Inapokea fonti ya PDF hii…';

  @override
  String get pdfFontDownloadFailed => 'Fonti ya PDF hii haikuweza kupokelewa. Angalia muunganisho wako wa intaneti kisha ujaribu tena.';

  @override
  String get packReceivingTitle => 'Inapokea kifurushi cha lugha…';

  @override
  String get packReceivedTitle => 'Kifurushi kimepokelewa';

  @override
  String get errorOfflinePackNeeded => 'Hakuna muunganisho wa intaneti. Lugha hii inahitaji kifurushi kinachopokelewa mara moja. Unganisha kwenye intaneti kisha ujaribu tena.';

  @override
  String get errorPackTooSlow => 'Kifurushi cha lugha kinachukua muda mrefu sana kupokelewa. Muunganisho wako wa intaneti unaweza kuwa dhaifu. Jaribu tena.';

  @override
  String get errorNoTextHint => 'Kwa tafsiri sahihi zaidi, tumia Andika maandishi. Changanua na Leta hufanya kazi vizuri zaidi na maandishi wazi ya herufi za Kilatini.';
}
