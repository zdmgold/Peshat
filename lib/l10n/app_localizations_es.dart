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
}
