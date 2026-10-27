import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peshat/core/providers/history_provider.dart';
import 'package:peshat/core/providers/notification_provider.dart';
import 'package:peshat/core/providers/purchase_provider.dart';
import 'package:peshat/core/providers/settings_provider.dart';
import 'package:peshat/core/providers/theme_provider.dart';
import 'package:peshat/core/providers/ui_locale_provider.dart';
import 'package:peshat/l10n/app_localizations.dart';
import 'package:peshat/screens/history_screen.dart';
import 'package:peshat/screens/language_picker_screen.dart';
import 'package:peshat/screens/settings_screen.dart';
import 'package:peshat/screens/ui_language_picker_screen.dart';

Future<SharedPreferences> _prefs(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues({'ads_removed': true, ...values});
  return SharedPreferences.getInstance();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screens in every menu language, real fonts', (t) async {
    final prefs = await _prefs({
      'theme_mode': 'light',
      'target_language': 'nl',
      'source_language': 'ja',
      'ui_locale': 'system',
    });
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

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

    final screens = <String, Widget Function()>{
      'settings': () => SettingsScreen(
            theme: ThemeProvider(prefs),
            purchase: PurchaseProvider(prefs),
            settings: SettingsProvider(prefs),
            history: HistoryProvider(prefs),
            uiLocale: UiLocaleProvider(prefs),
            notification: NotificationProvider(prefs),
          ),
      'ui-language-picker': () =>
          const UiLanguagePickerScreen(current: Locale('de')),
      'history': () => HistoryScreen(history: HistoryProvider(prefs)),
      'language-picker': () =>
          const LanguagePickerScreen(current: 'en', recents: ['fr', 'de']),
      'source-picker': () => const LanguagePickerScreen(
          current: 'auto', recents: ['hi'], sourceMode: true),
    };

    try {
      for (final locale in AppLocalizations.supportedLocales) {
       for (final scale in const [1.0, 1.3, 2.0]) {
        for (final s in screens.entries) {
          where = '${locale.languageCode} ${s.key} x$scale';
          await t.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: const Size(360, 640), textScaler: TextScaler.linear(scale)),
              child: CupertinoApp(
                key: ValueKey(where),
                locale: locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: s.value(),
              ),
            ),
          );
          await t.pump();
        }
       }
      }
    } finally {
      FlutterError.onError = original;
    }
    for (final p in problems) {
      // ignore: avoid_print
      print('EMU LOCALE OVERFLOW $p');
    }
    // ignore: avoid_print
    print('EMU LOCALE DONE ${problems.length} problems');
  });
}
