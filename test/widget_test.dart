import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    // Toolbar wordmark.
    expect(find.text('Peshat'), findsOneWidget);

    // Tagline.
    expect(find.textContaining('Point your camera'), findsOneWidget);

    // Primary card label.
    expect(find.text('Scan'), findsOneWidget);

    // Primary card renders the 56px SVG logo mark.
    // Note: HugeIcon wraps each icon in an internal SvgPicture,
    // so find.byType(SvgPicture) matches many. Target the 56px one.
    expect(
      find.byWidgetPredicate((w) => w is SvgPicture && w.width == 56),
      findsOneWidget,
    );

    // Secondary action cards.
    expect(find.text('Type text'), findsOneWidget);
    expect(find.text('Import a file'), findsOneWidget);

    // Language selector row.
    expect(find.text('Translate to: Spanish'), findsOneWidget);

    // Toolbar chips — three, one of each.
    expect(findHugeIcon(AppIcons.settings), findsOneWidget);
    expect(findHugeIcon(AppIcons.moon), findsOneWidget);
    // Globe appears twice: toolbar chip + language selector row.
    expect(findHugeIcon(AppIcons.globe), findsNWidgets(2));

    // Secondary action card icons.
    expect(findHugeIcon(AppIcons.typeText), findsOneWidget);
    expect(findHugeIcon(AppIcons.importFile), findsOneWidget);
  });
}
