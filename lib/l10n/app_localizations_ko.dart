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

  @override
  String get errorNoTextDetected => '이미지에서 텍스트를 찾을 수 없습니다';

  @override
  String get errorImageUnreadable => '이미지를 읽을 수 없습니다';

  @override
  String get errorModelDownloadFailed => '번역 모델을 다운로드할 수 없습니다';

  @override
  String get errorUnsupportedLanguage => '이 언어는 아직 지원되지 않습니다';

  @override
  String get errorOcrFailed => '텍스트 인식 실패';

  @override
  String get errorTranslationFailed => '번역 실패';

  @override
  String get errorTimeout => '작업이 너무 오래 걸렸습니다';

  @override
  String get errorUnknown => '문제가 발생했습니다';

  @override
  String get statusRecognizing => '텍스트 읽는 중…';

  @override
  String get statusPreparingModel => '번역 준비 중…';

  @override
  String get statusTranslating => '번역 중…';

  @override
  String get sourceLabel => '원문';

  @override
  String get translationLabel => '번역';

  @override
  String get retryButton => '다시 시도';

  @override
  String get changeLanguageButton => '언어 변경';

  @override
  String get historyLabel => '기록';

  @override
  String get defaultLanguageLabel => '기본 번역 언어';

  @override
  String get aboutLabel => '정보';

  @override
  String get licensesLabel => '오픈 소스 라이선스';

  @override
  String get shareAppLabel => '이 앱 공유';

  @override
  String get versionLabel => '버전';

  @override
  String get historyEmpty => '아직 스캔 기록이 없습니다';

  @override
  String get historyClearConfirm => '모든 기록을 삭제하시겠습니까?';

  @override
  String get termsLink => '서비스 약관';

  @override
  String get tagline => '카메라를 아무 텍스트에나 향하면 즉시 이해할 수 있습니다.';

  @override
  String get noResults => '결과 없음';

  @override
  String get copiedMessage => '클립보드에 복사됨';

  @override
  String get exportTxtAction => '텍스트로 내보내기';

  @override
  String get exportPdfAction => 'PDF로 내보내기';

  @override
  String get translatedTo => '번역 대상';

  @override
  String get translateToLabel => '번역 대상';

  @override
  String get typeTextLabel => '텍스트 입력 또는 붙여넣기';

  @override
  String get importFileLabel => '파일 가져오기';

  @override
  String get recentScansLabel => '최근 스캔';

  @override
  String get seeAllLabel => '모두 보기';

  @override
  String get uiLanguageLabel => '앱 언어';

  @override
  String get historyToday => '오늘';

  @override
  String get historyYesterday => '어제';

  @override
  String get historyOlder => '이전';

  @override
  String get typeTextButtonLabel => '텍스트 입력';

  @override
  String get removeAdsSubtitle => '일회성 구매';

  @override
  String get removeAdsShortLabel => '제거';

  @override
  String get charactersLabel => '자';

  @override
  String get clearHistoryLabel => '모든 기록 지우기';

  @override
  String get cameraLabel => '카메라';

  @override
  String get recentLanguagesLabel => '최근';

  @override
  String get allLanguagesLabel => '모든 언어';

  @override
  String get noResultsSubtitle => '다른 철자를 시도해 보세요.';

  @override
  String get sectionSystemLabel => '시스템';

  @override
  String get appLanguageLabel => '앱 언어';

  @override
  String get clearTextConfirm => '텍스트를 지우시겠습니까?';

  @override
  String get historyEmptySubtitle => '번역한 스캔이 여기에 표시됩니다.';
}
