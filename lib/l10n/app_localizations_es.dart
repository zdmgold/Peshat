// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Peshat';

  @override
  String get scanButtonLabel => 'Escanear documento';

  @override
  String get resultTitle => 'Resultado';

  @override
  String get copyAction => 'Copiar';

  @override
  String get shareAction => 'Compartir';

  @override
  String get saveAction => 'Guardar';

  @override
  String get readyToScan => 'Listo para escanear';

  @override
  String get selectLanguageTitle => 'Seleccionar idioma';

  @override
  String get searchLanguagesHint => 'Buscar idiomas...';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get adStatusLabel => 'Estado de anuncios:';

  @override
  String get adsShownStatus => 'Anuncios activos';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get removeAdsButton => 'Eliminar anuncios';

  @override
  String get restorePurchaseButton => 'Restaurar compra';

  @override
  String get privacyPolicyLink => 'Política de privacidad';

  @override
  String get supportLink => 'Soporte';

  @override
  String get adsRemovedBadge => 'Anuncios eliminados';

  @override
  String get semanticsAppIcon => 'Icono de la aplicación Peshat';

  @override
  String get semanticsScanButton => 'Botón Escanear documento';

  @override
  String get semanticsSearchField => 'Buscar idiomas';

  @override
  String get semanticsRemoveAds => 'Eliminar anuncios';

  @override
  String get cameraUsageDescription => 'Peshat usa la cámara para escanear texto y traducirlo. Las imágenes se procesan en el dispositivo y no se suben.';

  @override
  String get trackingUsageDescription => 'Se usa para mostrar anuncios no personalizados relevantes si rechaza; anuncios personalizados si acepta.';

  @override
  String get nativeAppName => 'Peshat';

  @override
  String semanticsLanguageEntry(String englishName, String nativeName) {
    return '$englishName, $nativeName';
  }

  @override
  String get errorNoTextDetected => 'No se encontró texto en la imagen';

  @override
  String get errorImageUnreadable => 'No se pudo leer la imagen';

  @override
  String get errorModelDownloadFailed => 'No se pudo descargar el modelo de traducción';

  @override
  String get errorUnsupportedLanguage => 'Este idioma aún no es compatible';

  @override
  String get errorOcrFailed => 'Falló el reconocimiento de texto';

  @override
  String get errorTranslationFailed => 'Falló la traducción';

  @override
  String get errorTimeout => 'La operación tardó demasiado';

  @override
  String get errorUnknown => 'Algo salió mal';

  @override
  String get statusRecognizing => 'Leyendo texto…';

  @override
  String get statusPreparingModel => 'Preparando traducción…';

  @override
  String get statusTranslating => 'Traduciendo…';

  @override
  String get sourceLabel => 'Original';

  @override
  String get translationLabel => 'Traducción';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get changeLanguageButton => 'Cambiar idioma';

  @override
  String get historyLabel => 'Historial';

  @override
  String get defaultLanguageLabel => 'Idioma de traducción predeterminado';

  @override
  String get aboutLabel => 'Acerca de';

  @override
  String get licensesLabel => 'Licencias de código abierto';

  @override
  String get shareAppLabel => 'Compartir esta aplicación';

  @override
  String get versionLabel => 'Versión';

  @override
  String get historyEmpty => 'Aún no hay escaneos';

  @override
  String get historyClearConfirm => '¿Eliminar todo el historial?';

  @override
  String get termsLink => 'Términos del servicio';
}
