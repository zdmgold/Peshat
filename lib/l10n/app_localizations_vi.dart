// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Quét tài liệu';

  @override
  String get resultTitle => 'Kết quả';

  @override
  String get copyAction => 'Sao chép';

  @override
  String get shareAction => 'Chia sẻ';

  @override
  String get saveAction => 'Lưu';

  @override
  String get readyToScan => 'Sẵn sàng quét';

  @override
  String get selectLanguageTitle => 'Chọn ngôn ngữ';

  @override
  String get searchLanguagesHint => 'Tìm kiếm ngôn ngữ...';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get adStatusLabel => 'Trạng thái quảng cáo:';

  @override
  String get adsShownStatus => 'Quảng cáo hiển thị';

  @override
  String get themeLabel => 'Chủ đề';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeDark => 'Tối';

  @override
  String get removeAdsButton => 'Xóa quảng cáo';

  @override
  String get restorePurchaseButton => 'Khôi phục mua hàng';

  @override
  String get privacyPolicyLink => 'Chính sách quyền riêng tư';

  @override
  String get supportLink => 'Hỗ trợ';

  @override
  String get adsRemovedBadge => 'Đã xóa quảng cáo';

  @override
  String get semanticsAppIcon => 'Biểu tượng ứng dụng Peshat';

  @override
  String get semanticsScanButton => 'Nút quét tài liệu';

  @override
  String get semanticsSearchField => 'Tìm kiếm ngôn ngữ';

  @override
  String get semanticsRemoveAds => 'Xóa quảng cáo';

  @override
  String get cameraUsageDescription => 'Peshat sử dụng camera để quét và dịch văn bản. Hình ảnh được xử lý trên thiết bị và không được tải lên.';

  @override
  String get trackingUsageDescription => 'Được sử dụng để hiển thị quảng cáo không được cá nhân hóa có liên quan nếu bạn từ chối; quảng cáo được cá nhân hóa nếu bạn cho phép.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
