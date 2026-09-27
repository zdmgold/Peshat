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
}
