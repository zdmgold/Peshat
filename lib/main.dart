import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/app_theme.dart';
import 'core/utils/error_handler.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/purchase_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/history_provider.dart';
import 'core/providers/ui_locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/scan_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installGlobalErrorHandling();
  final prefs = await SharedPreferences.getInstance();
  runApp(PeshatApp(prefs: prefs));
}

class PeshatApp extends StatefulWidget {
  final SharedPreferences prefs;
  const PeshatApp({required this.prefs, super.key});

  @override
  State<PeshatApp> createState() => _PeshatAppState();
}

class _PeshatAppState extends State<PeshatApp> {
  late final ThemeProvider themeProvider;
  late final PurchaseProvider purchaseProvider;
  late final SettingsProvider settingsProvider;
  late final HistoryProvider historyProvider;
  late final UiLocaleProvider uiLocaleProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = ThemeProvider(widget.prefs);
    purchaseProvider = PurchaseProvider(widget.prefs);
    settingsProvider = SettingsProvider(widget.prefs);
    historyProvider = HistoryProvider(widget.prefs);
    uiLocaleProvider = UiLocaleProvider(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeProvider, uiLocaleProvider]),
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: themeProvider.value,
        locale: uiLocaleProvider.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanScreen(
          theme: themeProvider,
          purchase: purchaseProvider,
          settings: settingsProvider,
          history: historyProvider,
          uiLocale: uiLocaleProvider,
        ),
      ),
    );
  }
}
