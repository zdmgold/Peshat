import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/notification_provider.dart';
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
          notification: NotificationProvider(prefs),
        ),
      ),
    );
    await tester.pump();

    // Large-title wordmark.
    expect(find.text('Peshat'), findsWidgets);

    // Primary action — label under the circular scan button.
    expect(find.text('Scan'), findsOneWidget);

    // Secondary actions — three text rows.
    expect(find.text('Type text'), findsOneWidget);
    expect(find.text('Import a file'), findsOneWidget);
    expect(find.text('Translate to: Spanish'), findsOneWidget);

    // Nav bar icons — three, one of each.
    expect(findHugeIcon(AppIcons.settings), findsOneWidget);
    expect(findHugeIcon(AppIcons.moon), findsOneWidget);
    expect(findHugeIcon(AppIcons.globe), findsOneWidget);

    // Body — the circular scan button's icon.
    expect(findHugeIcon(AppIcons.scanDocument), findsOneWidget);

    // The two secondary text actions have no leading icons.
    expect(findHugeIcon(AppIcons.typeText), findsNothing);
    expect(findHugeIcon(AppIcons.importFile), findsNothing);
  });
}
