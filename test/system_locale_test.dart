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
import 'package:peshat/main.dart';
import 'package:peshat/screens/history_screen.dart';
import 'package:peshat/screens/language_picker_screen.dart';
import 'package:peshat/screens/scan_screen.dart';
import 'package:peshat/screens/settings_screen.dart';
import 'package:peshat/screens/ui_language_picker_screen.dart';

const _rtl = {'ar', 'he', 'fa', 'ur'};

Future<SharedPreferences> _prefs(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues({'ads_removed': true, ...values});
  return SharedPreferences.getInstance();
}

/// The language the running app is showing on its home screen.
String _shown(WidgetTester tester) {
  final ctx = tester.element(find.byType(ScanScreen));
  return Localizations.localeOf(ctx).languageCode;
}

TextDirection _direction(WidgetTester tester) =>
    Directionality.of(tester.element(find.byType(ScanScreen)));

Future<void> _start(WidgetTester tester, SharedPreferences prefs) async {
  await tester.pumpWidget(PeshatApp(prefs: prefs));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('first install follows the system language, all 48', (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    final wrong = <String>[];
    for (final supported in AppLocalizations.supportedLocales) {
      final code = supported.languageCode;
      t.platformDispatcher.localesTestValue = [Locale(code)];
      await _start(t, await _prefs({}));
      if (_shown(t) != code) wrong.add('$code showed ${_shown(t)}');
      final want = _rtl.contains(code) ? TextDirection.rtl : TextDirection.ltr;
      if (_direction(t) != want) wrong.add('$code direction ${_direction(t)}');
    }
    expect(wrong, isEmpty);
  });

  testWidgets('system languages the app lacks fall back as designed',
      (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    final cases = <List<Locale>, String>{
      [const Locale('xx')]: 'en',
      [const Locale('xx'), const Locale('de')]: 'de',
      [const Locale('nb', 'NO')]: 'no',
      [const Locale('nn')]: 'no',
      [const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')]:
          'zh',
      [const Locale('pt', 'BR')]: 'pt',
      [const Locale('en', 'GB')]: 'en',
      [const Locale('iw')]: 'he',
      [const Locale('in')]: 'id',
      [const Locale('tl')]: 'fil',
    };
    final wrong = <String>[];
    for (final e in cases.entries) {
      t.platformDispatcher.localesTestValue = e.key;
      await _start(t, await _prefs({}));
      if (_shown(t) != e.value) {
        wrong.add('${e.key.map((l) => l.toLanguageTag())} -> ${_shown(t)} (want ${e.value})');
      }
    }
    expect(wrong, isEmpty);
  });

  testWidgets('manual choice beats the system language and survives a restart',
      (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    t.platformDispatcher.localesTestValue = [const Locale('ar')];
    final prefs = await _prefs({});
    await _start(t, prefs);
    expect(_shown(t), 'ar');

    // The user picks Japanese through the same provider the pickers use.
    UiLocaleProvider(prefs).setLocale(const Locale('ja'));
    await t.pumpWidget(const SizedBox());
    await _start(t, prefs); // app restart: same stored preferences
    expect(_shown(t), 'ja');

    // The system language changes while the choice stands: no effect.
    t.platformDispatcher.localesTestValue = [const Locale('fr')];
    await t.pump();
    expect(_shown(t), 'ja');

    // Back to "follow system": the system language applies again.
    UiLocaleProvider(prefs).setLocale(null);
    await t.pumpWidget(const SizedBox());
    await _start(t, prefs);
    expect(_shown(t), 'fr');
  });

  testWidgets('system language change while running is followed', (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    t.platformDispatcher.localesTestValue = [const Locale('de')];
    await _start(t, await _prefs({}));
    expect(_shown(t), 'de');
    t.platformDispatcher.localesTestValue = [const Locale('hi')];
    await t.pump();
    await t.pump(const Duration(milliseconds: 300));
    expect(_shown(t), 'hi');
  });

  testWidgets('a saved language the app no longer has falls back to system',
      (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    t.platformDispatcher.localesTestValue = [const Locale('es')];
    await _start(t, await _prefs({'ui_locale': 'xx'}));
    expect(_shown(t), 'es');
  });

  testWidgets('other screens have no overflow in any menu language',
      (t) async {
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

    // Settings is checked with real fonts on the emulator instead: this test
    // font is about 1.7 times too wide there and reports overflows that real
    // fonts do not have.
    final screens = <String, Widget Function()>{
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
        for (final s in screens.entries) {
          where = '${locale.languageCode} ${s.key}';
          await t.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(size: Size(360, 640)),
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
    } finally {
      FlutterError.onError = original;
    }
    for (final p in problems) {
      // ignore: avoid_print
      print('OVERFLOW $p');
    }
    expect(problems, isEmpty);
  });
}
