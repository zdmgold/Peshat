import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/subscription_provider.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/scan_screen.dart';

void main() {
  testWidgets('ScanScreen renders scan button', (tester) async {
    SharedPreferences.setMockInitialValues({'is_pro': true});
    final prefs = await SharedPreferences.getInstance();
    final subProvider = SubscriptionProvider(prefs);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanScreen(subProvider: subProvider),
      ),
    );

    expect(find.text('Scan Document'), findsOneWidget);
  });
}
