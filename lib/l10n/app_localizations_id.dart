// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Pindai Dokumen';

  @override
  String get resultTitle => 'Hasil';

  @override
  String get copyAction => 'Salin';

  @override
  String get shareAction => 'Bagikan';

  @override
  String get saveAction => 'Simpan';

  @override
  String get readyToScan => 'Siap memindai';

  @override
  String get selectLanguageTitle => 'Pilih Bahasa';

  @override
  String get searchLanguagesHint => 'Cari bahasa...';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get adStatusLabel => 'Status iklan:';

  @override
  String get adsShownStatus => 'Iklan ditampilkan';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get removeAdsButton => 'Hapus iklan';

  @override
  String get restorePurchaseButton => 'Pulihkan Pembelian';

  @override
  String get privacyPolicyLink => 'Kebijakan Privasi';

  @override
  String get supportLink => 'Dukungan';

  @override
  String get adsRemovedBadge => 'Iklan dihapus';

  @override
  String get semanticsAppIcon => 'Ikon Aplikasi Peshat';

  @override
  String get semanticsScanButton => 'Tombol Pindai Dokumen';

  @override
  String get semanticsSearchField => 'Cari bahasa';

  @override
  String get semanticsRemoveAds => 'Hapus iklan';

  @override
  String get cameraUsageDescription => 'Peshat menggunakan kamera untuk memindai dan menerjemahkan teks. Gambar diproses di perangkat dan tidak diunggah.';

  @override
  String get trackingUsageDescription => 'Digunakan untuk menampilkan iklan non-pribadi yang relevan jika Anda menolak; iklan pribadi jika Anda mengizinkan.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'Tidak ada teks dalam gambar';

  @override
  String get errorImageUnreadable => 'Gambar tidak dapat dibaca';

  @override
  String get errorModelDownloadFailed => 'Model terjemahan tidak dapat diunduh';

  @override
  String get errorUnsupportedLanguage => 'Bahasa ini belum didukung';

  @override
  String get errorOcrFailed => 'Pengenalan teks gagal';

  @override
  String get errorTranslationFailed => 'Terjemahan gagal';

  @override
  String get errorTimeout => 'Operasi memakan waktu terlalu lama';

  @override
  String get errorUnknown => 'Terjadi kesalahan';

  @override
  String get statusRecognizing => 'Membaca teks…';

  @override
  String get statusPreparingModel => 'Menyiapkan terjemahan…';

  @override
  String get statusTranslating => 'Menerjemahkan…';

  @override
  String get sourceLabel => 'Asli';

  @override
  String get translationLabel => 'Terjemahan';

  @override
  String get retryButton => 'Coba lagi';

  @override
  String get changeLanguageButton => 'Ubah bahasa';

  @override
  String get historyLabel => 'Riwayat';

  @override
  String get defaultLanguageLabel => 'Bahasa terjemahan bawaan';

  @override
  String get aboutLabel => 'Tentang';

  @override
  String get licensesLabel => 'Lisensi sumber terbuka';

  @override
  String get shareAppLabel => 'Bagikan aplikasi ini';

  @override
  String get versionLabel => 'Versi';

  @override
  String get historyEmpty => 'Belum ada pemindaian';

  @override
  String get historyClearConfirm => 'Hapus semua riwayat?';

  @override
  String get termsLink => 'Ketentuan Layanan';

  @override
  String get tagline => 'Arahkan kamera ke teks apa pun, pahami langsung.';

  @override
  String get noResults => 'Tidak ada hasil';

  @override
  String get copiedMessage => 'Disalin ke clipboard';

  @override
  String get exportTxtAction => 'Ekspor sebagai teks';

  @override
  String get exportPdfAction => 'Ekspor sebagai PDF';

  @override
  String get translatedTo => 'Diterjemahkan ke';

  @override
  String get translateToLabel => 'Terjemahkan ke';

  @override
  String get typeTextLabel => 'Ketik atau tempel teks';

  @override
  String get importFileLabel => 'Impor file';

  @override
  String get recentScansLabel => 'Pemindaian terbaru';

  @override
  String get seeAllLabel => 'Lihat semua';

  @override
  String get uiLanguageLabel => 'Bahasa aplikasi';

  @override
  String get historyToday => 'Hari ini';

  @override
  String get historyYesterday => 'Kemarin';

  @override
  String get historyOlder => 'Lebih lama';

  @override
  String get typeTextButtonLabel => 'Ketik teks';

  @override
  String get removeAdsSubtitle => 'Pembelian satu kali';

  @override
  String get removeAdsShortLabel => 'Hapus';

  @override
  String get charactersLabel => 'karakter';

  @override
  String get clearHistoryLabel => 'Hapus semua riwayat';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get recentLanguagesLabel => 'Terbaru';

  @override
  String get allLanguagesLabel => 'Semua bahasa';

  @override
  String get noResultsSubtitle => 'Coba ejaan lain.';

  @override
  String get sectionSystemLabel => 'Sistem';

  @override
  String get appLanguageLabel => 'Bahasa aplikasi';

  @override
  String get clearTextConfirm => 'Hapus teks?';

  @override
  String get historyEmptySubtitle => 'Pemindaian yang Anda terjemahkan akan muncul di sini.';
}
