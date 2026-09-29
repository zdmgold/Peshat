import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/purchase_provider.dart';
import 'package:peshat/core/providers/settings_provider.dart';
import 'package:peshat/core/providers/theme_provider.dart';
import 'package:peshat/core/providers/ui_locale_provider.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/scan_screen.dart';

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
      MaterialApp(
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

    // Wordmark appears in AppBar and hero.
    expect(find.text('Peshat'), findsWidgets);

    // Primary action.
    expect(find.text('Scan Document'), findsOneWidget);

    // Secondary actions.
    expect(find.text('Type text'), findsOneWidget);
    expect(find.text('Import a file'), findsOneWidget);

    // Target language card.
    expect(find.text('Translate to'), findsOneWidget);
    expect(find.byIcon(Icons.translate), findsOneWidget);

    // AppBar actions.
    expect(find.byIcon(Icons.language), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Scan icon appears in the Scan Document button.
    expect(find.byIcon(Icons.document_scanner_outlined), findsOneWidget);
  });
}
