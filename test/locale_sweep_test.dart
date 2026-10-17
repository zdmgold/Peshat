import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/notification_provider.dart';
import 'package:peshat/core/providers/purchase_provider.dart';
import 'package:peshat/core/providers/settings_provider.dart';
import 'package:peshat/core/providers/theme_provider.dart';
import 'package:peshat/core/providers/ui_locale_provider.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/scan_screen.dart';

/// Opens the Home screen in every menu language on a small phone and fails
/// if anything overflows its box. The test font draws every letter about as
/// wide as the letter is tall, roughly 1.7 times wider than real fonts, so
/// this is a stress test: a pass is a good sign, but it does not replace
/// looking at a real phone.
void main() {
  testWidgets('Home screen has no overflow in any menu language',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'ads_removed': true,
      'theme_mode': 'light',
      'target_language': 'nl',
      'ui_locale': 'system',
    });
    final prefs = await SharedPreferences.getInstance();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final problems = <String>[];
    var where = '';
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      final msg = details.exceptionAsString();
      if (msg.contains('overflowed')) {
        final text = details.toString().split('\n');
        final i = text.indexWhere((l) => l.contains('error-causing widget'));
        final widget = i >= 0
            ? text.skip(i + 1).take(3).map((l) => l.trim()).join(' ')
            : '';
        problems.add('$where: ${msg.split('\n').first} [$widget]');
      } else {
        original?.call(details);
      }
    };

    try {
      for (final locale in AppLocalizations.supportedLocales) {
        for (final scale in const [1.0]) {
          where = '${locale.languageCode} x$scale';
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 640),
                textScaler: TextScaler.linear(scale),
              ),
              child: CupertinoApp(
                key: ValueKey('${locale.languageCode}-$scale'),
                locale: locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
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
            ),
          );
          await tester.pump();
        }
      }
    } finally {
      FlutterError.onError = original;
    }
    // Print what was found so a failure can be read from the CI log.
    for (final p in problems) {
      // ignore: avoid_print
      print('OVERFLOW $p');
    }
    expect(problems, isEmpty);
  });
}
