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

  @override
  String get errorNoTextDetected => 'Không tìm thấy văn bản trong ảnh';

  @override
  String get errorImageUnreadable => 'Không thể đọc ảnh';

  @override
  String get errorModelDownloadFailed => 'Không thể tải xuống mô hình dịch';

  @override
  String get errorUnsupportedLanguage => 'Ngôn ngữ này chưa được hỗ trợ';

  @override
  String get errorOcrFailed => 'Nhận dạng văn bản thất bại';

  @override
  String get errorTranslationFailed => 'Dịch thất bại';

  @override
  String get errorTimeout => 'Thao tác mất quá nhiều thời gian';

  @override
  String get errorUnknown => 'Đã xảy ra lỗi';

  @override
  String get statusRecognizing => 'Đang đọc văn bản…';

  @override
  String get statusPreparingModel => 'Đang chuẩn bị dịch…';

  @override
  String get statusTranslating => 'Đang dịch…';

  @override
  String get sourceLabel => 'Bản gốc';

  @override
  String get translationLabel => 'Bản dịch';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get changeLanguageButton => 'Đổi ngôn ngữ';

  @override
  String get historyLabel => 'Lịch sử';

  @override
  String get defaultLanguageLabel => 'Ngôn ngữ dịch mặc định';

  @override
  String get aboutLabel => 'Giới thiệu';

  @override
  String get licensesLabel => 'Giấy phép mã nguồn mở';

  @override
  String get shareAppLabel => 'Chia sẻ ứng dụng này';

  @override
  String get versionLabel => 'Phiên bản';

  @override
  String get historyEmpty => 'Chưa có bản quét nào';

  @override
  String get historyClearConfirm => 'Xóa toàn bộ lịch sử?';

  @override
  String get termsLink => 'Điều khoản dịch vụ';

  @override
  String get tagline => 'Hướng camera vào bất kỳ văn bản nào, hiểu ngay lập tức.';

  @override
  String get noResults => 'Không có kết quả';

  @override
  String get copiedMessage => 'Đã sao chép vào clipboard';

  @override
  String get exportTxtAction => 'Xuất dưới dạng văn bản';

  @override
  String get exportPdfAction => 'Xuất dưới dạng PDF';

  @override
  String get translatedTo => 'Đã dịch sang';

  @override
  String get translateToLabel => 'Dịch sang';

  @override
  String get typeTextLabel => 'Nhập hoặc dán văn bản';

  @override
  String get importFileLabel => 'Nhập tệp';

  @override
  String get recentScansLabel => 'Lần quét gần đây';

  @override
  String get seeAllLabel => 'Xem tất cả';

  @override
  String get uiLanguageLabel => 'Ngôn ngữ ứng dụng';

  @override
  String get historyToday => 'Hôm nay';

  @override
  String get historyYesterday => 'Hôm qua';

  @override
  String get historyOlder => 'Cũ hơn';

  @override
  String get typeTextButtonLabel => 'Nhập văn bản';

  @override
  String get removeAdsSubtitle => 'Mua một lần';

  @override
  String get removeAdsShortLabel => 'Gỡ';

  @override
  String get charactersLabel => 'ký tự';

  @override
  String get clearHistoryLabel => 'Xóa toàn bộ lịch sử';

  @override
  String get cameraLabel => 'Máy ảnh';

  @override
  String get recentLanguagesLabel => 'Gần đây';

  @override
  String get allLanguagesLabel => 'Tất cả ngôn ngữ';

  @override
  String get noResultsSubtitle => 'Thử cách viết khác.';

  @override
  String get sectionSystemLabel => 'Hệ thống';

  @override
  String get appLanguageLabel => 'Ngôn ngữ ứng dụng';

  @override
  String get clearTextConfirm => 'Xóa văn bản?';

  @override
  String get historyEmptySubtitle => 'Các bản quét bạn dịch sẽ xuất hiện ở đây.';

  @override
  String get cancelButtonLabel => 'Hủy';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => 'Đóng';

  @override
  String get showMenuTooltip => 'Hiện menu';

  @override
  String get licensePackageLabel => 'Gói';

  @override
  String get licenseEmptyLabel => 'Không có thông tin giấy phép.';

  @override
  String get rateAppLabel => 'Đánh giá Peshat';
}
