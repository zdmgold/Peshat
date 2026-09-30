import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/purchase_provider.dart';
import 'package:peshat/core/providers/settings_provider.dart';
import 'package:peshat/core/providers/theme_provider.dart';
import 'package:peshat/core/providers/ui_locale_provider.dart';
import 'package:peshat/core/utils/app_icons.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/scan_screen.dart';

/// Helper: find a [HugeIcon] rendered from a specific icon constant.
/// Flutter's `find.byIcon` only matches the built-in [Icon] widget, so
/// Hugeicons needs a widget-predicate finder.
Finder findHugeIcon(List<List<dynamic>> icon) =>
    find.byWidgetPredicate((w) => w is HugeIcon && w.icon == icon);

void main() {
  testWidgets('ScanScreen renders core controls', (tester) async {
    SharedPreferences.setMockInitialValues({
      'ads_removed': true,
      'theme_mode': 'light',
      'target_language': 'es',
      'ui_locale': 'system',
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanScreen(
          theme: ThemeProvider(prefs),
          purchase: PurchaseProvider(prefs),
          settings: SettingsProvider(prefs),
          history: HistoryProvider(prefs),
          uiLocale: UiLocaleProvider(prefs),
        ),
      ),
    );
    await tester.pump();

    // Wordmark appears in the nav bar and in the hero.
    expect(find.text('Peshat'), findsWidgets);

    // Primary action.
    expect(find.text('Scan Document'), findsOneWidget);

    // Secondary actions.
    expect(find.text('Type text'), findsOneWidget);
    expect(find.text('Import a file'), findsOneWidget);

    // Target language card.
    expect(find.text('Translate to'), findsOneWidget);

    // Nav bar icons — one of each.
    expect(findHugeIcon(AppIcons.settings), findsOneWidget);
    expect(findHugeIcon(AppIcons.moon), findsOneWidget);

    // Globe appears in the nav bar (UI language) and in the
    // "Translate to" card. Two occurrences.
    expect(findHugeIcon(AppIcons.globe), findsNWidgets(2));

    // Body icons — one of each.
    expect(findHugeIcon(AppIcons.scanDocument), findsOneWidget);
    expect(findHugeIcon(AppIcons.typeText), findsOneWidget);
    expect(findHugeIcon(AppIcons.importFile), findsOneWidget);
  });
}
