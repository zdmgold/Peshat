// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => '문서 스캔';

  @override
  String get resultTitle => '결과';

  @override
  String get copyAction => '복사';

  @override
  String get shareAction => '공유';

  @override
  String get saveAction => '저장';

  @override
  String get readyToScan => '스캔 준비 완료';

  @override
  String get selectLanguageTitle => '언어 선택';

  @override
  String get searchLanguagesHint => '언어 검색...';

  @override
  String get settingsTitle => '설정';

  @override
  String get adStatusLabel => '광고 상태:';

  @override
  String get adsShownStatus => '광고 표시됨';

  @override
  String get themeLabel => '테마';

  @override
  String get themeLight => '밝게';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeDark => '어둡게';

  @override
  String get removeAdsButton => '광고 제거';

  @override
  String get restorePurchaseButton => '구매 복원';

  @override
  String get privacyPolicyLink => '개인정보처리방침';

  @override
  String get supportLink => '지원';

  @override
  String get adsRemovedBadge => '광고 제거됨';

  @override
  String get semanticsAppIcon => 'Peshat 앱 아이콘';

  @override
  String get semanticsScanButton => '문서 스캔 버튼';

  @override
  String get semanticsSearchField => '언어 검색';

  @override
  String get semanticsRemoveAds => '광고 제거';

  @override
  String get cameraUsageDescription => 'Peshat은 카메라를 사용하여 텍스트를 스캔하고 번역합니다. 이미지는 기기에서 처리되며 업로드되지 않습니다.';

  @override
  String get trackingUsageDescription => '거부할 경우 관련 비개인화 광고를 표시하는 데 사용되며, 동의할 경우 개인화 광고를 표시하는 데 사용됩니다.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
