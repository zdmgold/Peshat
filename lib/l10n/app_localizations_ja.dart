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

  @override
  String get errorNoTextDetected => '画像にテキストが見つかりません';

  @override
  String get errorImageUnreadable => '画像を読み取れませんでした';

  @override
  String get errorModelDownloadFailed => '翻訳モデルをダウンロードできませんでした';

  @override
  String get errorUnsupportedLanguage => 'この言語はまだ対応していません';

  @override
  String get errorOcrFailed => 'テキスト認識に失敗しました';

  @override
  String get errorTranslationFailed => '翻訳に失敗しました';

  @override
  String get errorTimeout => '操作に時間がかかりすぎました';

  @override
  String get errorUnknown => '問題が発生しました';

  @override
  String get statusRecognizing => 'テキストを読み取り中…';

  @override
  String get statusPreparingModel => '翻訳を準備中…';

  @override
  String get statusTranslating => '翻訳中…';

  @override
  String get sourceLabel => '原文';

  @override
  String get translationLabel => '翻訳';

  @override
  String get retryButton => '再試行';

  @override
  String get changeLanguageButton => '言語を変更';

  @override
  String get historyLabel => '履歴';

  @override
  String get defaultLanguageLabel => 'デフォルトの翻訳先言語';

  @override
  String get aboutLabel => 'このアプリについて';

  @override
  String get licensesLabel => 'オープンソースライセンス';

  @override
  String get shareAppLabel => 'このアプリを共有';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get historyEmpty => 'スキャン履歴はまだありません';

  @override
  String get historyClearConfirm => 'すべての履歴を削除しますか？';

  @override
  String get termsLink => '利用規約';

  @override
  String get tagline => 'カメラを任意のテキストに向けて、すぐに理解しましょう。';

  @override
  String get noResults => '結果がありません';

  @override
  String get copiedMessage => 'クリップボードにコピーしました';

  @override
  String get exportTxtAction => 'テキストとしてエクスポート';

  @override
  String get exportPdfAction => 'PDFとしてエクスポート';

  @override
  String get translatedTo => '翻訳先';

  @override
  String get translateToLabel => '翻訳先';

  @override
  String get typeTextLabel => 'テキストを入力または貼り付け';

  @override
  String get importFileLabel => 'ファイルをインポート';

  @override
  String get recentScansLabel => '最近のスキャン';

  @override
  String get seeAllLabel => 'すべて表示';

  @override
  String get uiLanguageLabel => 'アプリの言語';

  @override
  String get historyToday => '今日';

  @override
  String get historyYesterday => '昨日';

  @override
  String get historyOlder => 'それ以前';

  @override
  String get typeTextButtonLabel => 'テキストを入力';

  @override
  String get removeAdsSubtitle => '買い切り';

  @override
  String get removeAdsShortLabel => '削除';

  @override
  String get charactersLabel => '文字';

  @override
  String get clearHistoryLabel => 'すべての履歴を消去';

  @override
  String get cameraLabel => 'カメラ';

  @override
  String get recentLanguagesLabel => '最近';

  @override
  String get allLanguagesLabel => 'すべての言語';

  @override
  String get noResultsSubtitle => '別の綴りをお試しください。';

  @override
  String get sectionSystemLabel => 'システム';

  @override
  String get appLanguageLabel => 'アプリの言語';

  @override
  String get clearTextConfirm => 'テキストを消去しますか？';

  @override
  String get historyEmptySubtitle => '翻訳したスキャンはここに表示されます。';

  @override
  String get cancelButtonLabel => 'キャンセル';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get closeButtonTooltip => '閉じる';

  @override
  String get showMenuTooltip => 'メニューを表示';

  @override
  String get licensePackageLabel => 'パッケージ';

  @override
  String get licenseEmptyLabel => 'ライセンス情報がありません。';

  @override
  String get rateAppLabel => 'Peshatを評価';

  @override
  String get notificationsSectionLabel => '通知';

  @override
  String get reminderNotificationsLabel => 'リマインダー';

  @override
  String get reminderNotificationsSubtitle => '数日間Peshatを使用していない場合にリマインダーを受け取ります。';

  @override
  String get reminderNotificationTitle => '翻訳を続けましょう';

  @override
  String get reminderNotificationBody => 'Peshatで中断したところから再開しましょう。';

  @override
  String get notificationPermissionDenied => 'リマインダーを受け取るには、システム設定で通知を有効にしてください。';

  @override
  String get scanShortLabel => 'スキャン';

  @override
  String get recentLabel => '最近';
}
