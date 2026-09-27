// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'ドキュメントをスキャン';

  @override
  String get resultTitle => '結果';

  @override
  String get copyAction => 'コピー';

  @override
  String get shareAction => '共有';

  @override
  String get saveAction => '保存';

  @override
  String get readyToScan => 'スキャンの準備完了';

  @override
  String get selectLanguageTitle => '言語を選択';

  @override
  String get searchLanguagesHint => '言語を検索...';

  @override
  String get settingsTitle => '設定';

  @override
  String get adStatusLabel => '広告ステータス:';

  @override
  String get adsShownStatus => '広告表示中';

  @override
  String get themeLabel => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeDark => 'ダーク';

  @override
  String get removeAdsButton => '広告を削除';

  @override
  String get restorePurchaseButton => '購入を復元';

  @override
  String get privacyPolicyLink => 'プライバシーポリシー';

  @override
  String get supportLink => 'サポート';

  @override
  String get adsRemovedBadge => '広告削除済み';

  @override
  String get semanticsAppIcon => 'Peshatアプリアイコン';

  @override
  String get semanticsScanButton => 'ドキュメントスキャンボタン';

  @override
  String get semanticsSearchField => '言語を検索';

  @override
  String get semanticsRemoveAds => '広告を削除';

  @override
  String get cameraUsageDescription => 'Peshatはカメラを使用してテキストをスキャンし、翻訳します。画像はデバイス上で処理され、アップロードされることはありません。';

  @override
  String get trackingUsageDescription => '拒否した場合は関連する非パーソナライズ広告を、同意した場合はパーソナライズ広告を表示するために使用されます。';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName、$nativeName';
  }
}
