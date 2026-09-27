// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Digitalizar documento';

  @override
  String get resultTitle => 'Resultado';

  @override
  String get copyAction => 'Copiar';

  @override
  String get shareAction => 'Compartilhar';

  @override
  String get saveAction => 'Salvar';

  @override
  String get readyToScan => 'Pronto para digitalizar';

  @override
  String get selectLanguageTitle => 'Selecionar idioma';

  @override
  String get searchLanguagesHint => 'Pesquisar idiomas...';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get adStatusLabel => 'Estado dos anúncios:';

  @override
  String get adsShownStatus => 'Anúncios exibidos';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get removeAdsButton => 'Remover anúncios';

  @override
  String get restorePurchaseButton => 'Restaurar compra';

  @override
  String get privacyPolicyLink => 'Política de privacidade';

  @override
  String get supportLink => 'Suporte';

  @override
  String get adsRemovedBadge => 'Anúncios removidos';

  @override
  String get semanticsAppIcon => 'Ícone do aplicativo Peshat';

  @override
  String get semanticsScanButton => 'Botão Digitalizar documento';

  @override
  String get semanticsSearchField => 'Pesquisar idiomas';

  @override
  String get semanticsRemoveAds => 'Remover anúncios';

  @override
  String get cameraUsageDescription => 'O Peshat usa a câmera para digitalizar texto e traduzi-lo. As imagens são processadas no dispositivo e não são enviadas.';

  @override
  String get trackingUsageDescription => 'Usado para mostrar anúncios não personalizados relevantes se você recusar; anúncios personalizados se você permitir.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }
}
