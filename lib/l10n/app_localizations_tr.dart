// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Belgeyi Tara';

  @override
  String get resultTitle => 'Sonuç';

  @override
  String get copyAction => 'Kopyala';

  @override
  String get shareAction => 'Paylaş';

  @override
  String get saveAction => 'Kaydet';

  @override
  String get readyToScan => 'Taramaya hazır';

  @override
  String get selectLanguageTitle => 'Dil Seçin';

  @override
  String get searchLanguagesHint => 'Dil ara...';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get adStatusLabel => 'Reklam durumu:';

  @override
  String get adsShownStatus => 'Reklamlar gösteriliyor';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Koyu';

  @override
  String get removeAdsButton => 'Reklamları kaldır';

  @override
  String get restorePurchaseButton => 'Satın Almayı Geri Yükle';

  @override
  String get privacyPolicyLink => 'Gizlilik Politikası';

  @override
  String get supportLink => 'Destek';

  @override
  String get adsRemovedBadge => 'Reklamlar kaldırıldı';

  @override
  String get semanticsAppIcon => 'Peshat Uygulama Simgesi';

  @override
  String get semanticsScanButton => 'Belgeyi Tara Düğmesi';

  @override
  String get semanticsSearchField => 'Dil ara';

  @override
  String get semanticsRemoveAds => 'Reklamları kaldır';

  @override
  String get cameraUsageDescription => 'Peshat metni taramak ve çevirmek için kamerayı kullanır. Görüntüler cihazda işlenir ve yüklenmez.';

  @override
  String get trackingUsageDescription => 'Reddederseniz ilgili kişiselleştirilmemiş reklamları; kabul ederseniz kişiselleştirilmiş reklamları göstermek için kullanılır.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
