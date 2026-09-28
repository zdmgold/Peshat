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

  @override
  String get errorNoTextDetected => 'Nenhum texto encontrado na imagem';

  @override
  String get errorImageUnreadable => 'Não foi possível ler a imagem';

  @override
  String get errorModelDownloadFailed => 'Não foi possível baixar o modelo de tradução';

  @override
  String get errorUnsupportedLanguage => 'Este idioma ainda não é compatível';

  @override
  String get errorOcrFailed => 'Falha no reconhecimento de texto';

  @override
  String get errorTranslationFailed => 'Falha na tradução';

  @override
  String get errorTimeout => 'A operação demorou demais';

  @override
  String get errorUnknown => 'Algo deu errado';

  @override
  String get statusRecognizing => 'Lendo texto…';

  @override
  String get statusPreparingModel => 'Preparando tradução…';

  @override
  String get statusTranslating => 'Traduzindo…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Tradução';

  @override
  String get retryButton => 'Tentar novamente';

  @override
  String get changeLanguageButton => 'Alterar idioma';

  @override
  String get historyLabel => 'Histórico';

  @override
  String get defaultLanguageLabel => 'Idioma de tradução padrão';

  @override
  String get aboutLabel => 'Sobre';

  @override
  String get licensesLabel => 'Licenças de código aberto';

  @override
  String get shareAppLabel => 'Compartilhar este aplicativo';

  @override
  String get versionLabel => 'Versão';

  @override
  String get historyEmpty => 'Nenhuma digitalização ainda';

  @override
  String get historyClearConfirm => 'Excluir todo o histórico?';

  @override
  String get termsLink => 'Termos de Serviço';

  @override
  String get tagline => 'Aponte a câmera para qualquer texto e entenda na hora.';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get copiedMessage => 'Copiado para a área de transferência';

  @override
  String get exportTxtAction => 'Exportar como texto';

  @override
  String get exportPdfAction => 'Exportar como PDF';

  @override
  String get translatedTo => 'Traduzido para';

  @override
  String get translateToLabel => 'Traduzir para';

  @override
  String get typeTextLabel => 'Digite ou cole o texto';

  @override
  String get importFileLabel => 'Importar um arquivo';

  @override
  String get recentScansLabel => 'Digitalizações recentes';

  @override
  String get seeAllLabel => 'Ver tudo';

  @override
  String get uiLanguageLabel => 'Idioma do aplicativo';

  @override
  String get historyToday => 'Hoje';

  @override
  String get historyYesterday => 'Ontem';

  @override
  String get historyOlder => 'Mais antigo';

  @override
  String get typeTextButtonLabel => 'Digitar texto';
}
