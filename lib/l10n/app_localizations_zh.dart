// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => '扫描文档';

  @override
  String get resultTitle => '结果';

  @override
  String get copyAction => '复制';

  @override
  String get shareAction => '分享';

  @override
  String get saveAction => '保存';

  @override
  String get readyToScan => '准备扫描';

  @override
  String get selectLanguageTitle => '选择语言';

  @override
  String get searchLanguagesHint => '搜索语言...';

  @override
  String get settingsTitle => '设置';

  @override
  String get adStatusLabel => '广告状态：';

  @override
  String get adsShownStatus => '显示广告';

  @override
  String get themeLabel => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeDark => '深色';

  @override
  String get removeAdsButton => '移除广告';

  @override
  String get restorePurchaseButton => '恢复购买';

  @override
  String get privacyPolicyLink => '隐私政策';

  @override
  String get supportLink => '支持';

  @override
  String get adsRemovedBadge => '已移除广告';

  @override
  String get semanticsAppIcon => 'Peshat 应用图标';

  @override
  String get semanticsScanButton => '扫描文档按钮';

  @override
  String get semanticsSearchField => '搜索语言';

  @override
  String get semanticsRemoveAds => '移除广告';

  @override
  String get cameraUsageDescription => 'Peshat 使用摄像头扫描文本进行翻译。图像在设备上处理，不会上传。';

  @override
  String get trackingUsageDescription => '用于在您拒绝时显示相关的非个性化广告；在您允许时显示个性化广告。';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName、$nativeName';
  }

  @override
  String get errorNoTextDetected => '图像中未找到文本';

  @override
  String get errorImageUnreadable => '无法读取图像';

  @override
  String get errorModelDownloadFailed => '无法下载翻译模型';

  @override
  String get errorUnsupportedLanguage => '暂不支持此语言';

  @override
  String get errorOcrFailed => '文字识别失败';

  @override
  String get errorTranslationFailed => '翻译失败';

  @override
  String get errorTimeout => '操作耗时过长';

  @override
  String get errorUnknown => '出现错误';

  @override
  String get statusRecognizing => '正在读取文字…';

  @override
  String get statusPreparingModel => '正在准备翻译…';

  @override
  String get statusTranslating => '正在翻译…';

  @override
  String get sourceLabel => '原文';

  @override
  String get translationLabel => '译文';

  @override
  String get retryButton => '重试';

  @override
  String get changeLanguageButton => '切换语言';

  @override
  String get historyLabel => '历史记录';

  @override
  String get defaultLanguageLabel => '默认翻译语言';

  @override
  String get aboutLabel => '关于';

  @override
  String get licensesLabel => '开源许可';

  @override
  String get shareAppLabel => '分享此应用';

  @override
  String get versionLabel => '版本';

  @override
  String get historyEmpty => '暂无扫描记录';

  @override
  String get historyClearConfirm => '删除所有历史记录？';

  @override
  String get termsLink => '服务条款';

  @override
  String get tagline => '将相机对准任意文字，即刻理解。';

  @override
  String get noResults => '无结果';

  @override
  String get copiedMessage => '已复制到剪贴板';

  @override
  String get exportTxtAction => '导出为文本';

  @override
  String get exportPdfAction => '导出为 PDF';

  @override
  String get translatedTo => '翻译为';

  @override
  String get translateToLabel => '翻译为';

  @override
  String get typeTextLabel => '输入或粘贴文本';

  @override
  String get importFileLabel => '导入文件';

  @override
  String get recentScansLabel => '最近的扫描';

  @override
  String get seeAllLabel => '查看全部';

  @override
  String get uiLanguageLabel => '应用语言';

  @override
  String get historyToday => '今天';

  @override
  String get historyYesterday => '昨天';

  @override
  String get historyOlder => '更早';

  @override
  String get typeTextButtonLabel => '输入文字';

  @override
  String get removeAdsSubtitle => '一次性购买';

  @override
  String get removeAdsShortLabel => '移除';

  @override
  String get charactersLabel => '个字符';

  @override
  String get clearHistoryLabel => '清除所有历史记录';

  @override
  String get cameraLabel => '相机';

  @override
  String get recentLanguagesLabel => '最近';

  @override
  String get allLanguagesLabel => '所有语言';

  @override
  String get noResultsSubtitle => '请尝试其他拼写。';

  @override
  String get sectionSystemLabel => '系统';

  @override
  String get appLanguageLabel => '应用语言';

  @override
  String get clearTextConfirm => '清除文本？';
}
