import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:in_app_purchase/in_app_purchase.dart'
    show InAppPurchase, PurchaseDetails, PurchaseStatus;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/iap_service.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/error_handler.dart';
import 'core/models/app_theme_mode.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/purchase_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/history_provider.dart';
import 'core/providers/ui_locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/services/interstitial_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers/notification_provider.dart';
import 'widgets/ad_slot.dart';
import 'screens/scan_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installGlobalErrorHandling();
  final prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool('ads_removed') ?? false)) {
    unawaited(MobileAds.instance.initialize());
  }
  await InterstitialService.instance.init(prefs);
  await NotificationService.instance.init(prefs);
  runApp(PeshatApp(prefs: prefs));
}

class PeshatApp extends StatefulWidget {
  final SharedPreferences prefs;
  const PeshatApp({required this.prefs, super.key});

  @override
  State<PeshatApp> createState() => _PeshatAppState();
}

class _PeshatAppState extends State<PeshatApp> with WidgetsBindingObserver {
  late final ThemeProvider themeProvider;
  late final PurchaseProvider purchaseProvider;
  late final SettingsProvider settingsProvider;
  late final HistoryProvider historyProvider;
  late final UiLocaleProvider uiLocaleProvider;
  late final NotificationProvider notificationProvider;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  Brightness _platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    themeProvider = ThemeProvider(widget.prefs);
    purchaseProvider = PurchaseProvider(widget.prefs);
    settingsProvider = SettingsProvider(widget.prefs);
    historyProvider = HistoryProvider(widget.prefs);
    uiLocaleProvider = UiLocaleProvider(widget.prefs);
    notificationProvider = NotificationProvider(widget.prefs);

    AdSlot.setPurchased(purchaseProvider.value);
    InterstitialService.instance.setPurchased(purchaseProvider.value);
    purchaseProvider.addListener(_syncAdSlot);
    _listenForPurchases();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    purchaseProvider.removeListener(_syncAdSlot);
    _purchaseSub?.cancel();
    super.dispose();
  }

  /// Receives every purchase / restore result from the store. Without this
  /// listener a "Remove ads" purchase is never acknowledged or applied.
  void _listenForPurchases() {
    try {
      _purchaseSub = InAppPurchase.instance.purchaseStream.listen(
        _onPurchaseUpdates,
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      final owned = p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored;
      if (owned && p.productID == IapService.removeAdsProductId) {
        purchaseProvider.markAdsRemoved(widget.prefs);
      }
      if (p.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(p);
        } catch (_) {}
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

  void _syncAdSlot() {
    AdSlot.setPurchased(purchaseProvider.value);
    InterstitialService.instance.setPurchased(purchaseProvider.value);
  }

  CupertinoThemeData _resolveTheme(AppThemeMode mode) {
    final isDark = mode == AppThemeMode.dark ||
        (mode == AppThemeMode.system &&
            _platformBrightness == Brightness.dark);
    return isDark ? buildDarkCupertinoTheme() : buildLightCupertinoTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeProvider, uiLocaleProvider]),
      builder: (context, _) => CupertinoApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        debugShowCheckedModeBanner: false,
        theme: _resolveTheme(themeProvider.value),
        locale: uiLocaleProvider.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanScreen(
          theme: themeProvider,
          purchase: purchaseProvider,
          settings: settingsProvider,
          history: historyProvider,
          uiLocale: uiLocaleProvider,
          notification: notificationProvider,
        ),
      ),
    );
  }
}
