// Real-device walk-through of the app on an emulator (see emulator-test.yml).
// Never fails fast: every step is recorded, and the test fails at the end if
// any step threw or any layout exception was reported. Real-font sizes are
// printed as "SIZE ..." lines so heights can be read from the log.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/utils/app_icons.dart';
import 'package:peshat/main.dart' as app;
import 'package:peshat/widgets/peshat_icon.dart';

final List<String> _problems = <String>[];

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

Future<void> _settle(WidgetTester t, [int ms = 1500]) async {
  await t.pump(Duration(milliseconds: ms));
  await t.pump(const Duration(milliseconds: 300));
}

void _size(WidgetTester t, String name, Finder f) {
  if (f.evaluate().isEmpty) {
    _log('SIZE $name: not found');
    return;
  }
  final Size s = t.getSize(f.first);
  _log('SIZE $name: ${s.width.toStringAsFixed(1)} x ${s.height.toStringAsFixed(1)}');
}

Future<void> _step(WidgetTester t, String name, Future<void> Function() body) async {
  _log('STEP $name');
  try {
    await body();
    await _settle(t, 600);
  } catch (e) {
    _problems.add('$name: $e');
    _log('PROBLEM $name: $e');
  }
  final dynamic ex = t.takeException();
  if (ex != null) {
    _problems.add('$name (framework): $ex');
    _log('PROBLEM $name (framework): $ex');
  }
}

void _pop(WidgetTester t) {
  final NavigatorState nav = t.state<NavigatorState>(find.byType(Navigator).first);
  nav.pop();
}

Future<void> _pick(WidgetTester t, String subtitle) async {
  final Finder f = find.text(subtitle);
  await t.scrollUntilVisible(f, 300,
      scrollable: find.byType(Scrollable).first, maxScrolls: 60);
  await t.tap(f.first);
}

Future<void> _tapText(WidgetTester t, String text) async {
  final Finder f = find.text(text);
  if (f.evaluate().isEmpty) throw 'text not found: "$text"';
  await t.tap(f.first);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('walk through the main screens', (WidgetTester t) async {
    app.main();
    await _settle(t, 4000);

    await _step(t, 'home', () async {
      expect(find.text('Source language'), findsOneWidget);
      expect(find.text('Destination language'), findsOneWidget);
      _size(t, 'home language card', find.text('Source language'));
      final Finder card = find.ancestor(
          of: find.text('Source language'), matching: find.byType(IntrinsicHeight));
      _size(t, 'home pair card (IntrinsicHeight)', card);
      _size(t, 'home Type text', find.text('Type text'));
    });

    await _step(t, 'source picker opens', () async {
      await _tapText(t, 'Source language');
      await _settle(t);
      expect(find.text('CAMERA CAN READ'), findsOneWidget);
      _size(t, 'picker Auto row', find.textContaining('Auto'));
    });

    await _step(t, 'choose Japanese as source', () async {
      await _pick(t, 'Japanese');
      await _settle(t);
      expect(find.text('Source language'), findsOneWidget);
      expect(find.textContaining('日本語'), findsWidgets);
      _size(t, 'home pair after Japanese',
          find.ancestor(of: find.text('Source language'), matching: find.byType(IntrinsicHeight)));
    });

    await _step(t, 'choose Russian (type-only) as source', () async {
      await _tapText(t, 'Source language');
      await _settle(t);
      await _pick(t, 'Russian');
      await _settle(t);
      expect(find.textContaining('Русский'), findsWidgets);
    });

    await _step(t, 'back to Auto', () async {
      await _tapText(t, 'Source language');
      await _settle(t);
      await t.tap(find.textContaining('Auto').first);
      await _settle(t);
    });

    await _step(t, 'destination picker + switch live', () async {
      await _tapText(t, 'Destination language');
      await _settle(t);
      await _pick(t, 'French');
      await _settle(t);
      expect(find.textContaining('Français'), findsWidgets);
    });

    await _step(t, 'Type text screen', () async {
      await _tapText(t, 'Type text');
      await _settle(t);
      expect(find.text('Translate to'), findsOneWidget);
      _size(t, 'Type text card', find.text('Translate to'));
      await t.enterText(find.byType(CupertinoTextField).first, 'Good morning, how are you?');
      await _settle(t, 500);
    });

    await _step(t, 'translate (needs model download; soft)', () async {
      await _tapText(t, 'Translation');
      for (int i = 0; i < 45; i++) {
        await t.pump(const Duration(seconds: 2));
        if (find.text('Result').evaluate().isNotEmpty &&
            find.textContaining('Bonjour').evaluate().isNotEmpty) {
          break;
        }
      }
      _log('RESULT screen: ${find.text('Result').evaluate().isNotEmpty}, '
          'Bonjour: ${find.textContaining('Bonjour').evaluate().isNotEmpty}');
      _size(t, 'result language line', find.textContaining('Français'));
      final bool boxes = find
          .byWidgetPredicate((Widget w) =>
              w is PeshatIcon && identical(w.icon, AppIcons.chevronDown))
          .evaluate()
          .isNotEmpty;
      _log('RESULT down-chevron icon present: $boxes');
    });

    await _step(t, 'result tabs', () async {
      if (find.text('Original').evaluate().isNotEmpty) {
        await t.tap(find.text('Original').first);
        await _settle(t);
        await t.tap(find.text('Translation').first);
        await _settle(t);
      }
    });

    for (int i = 0; i < 3; i++) {
      _pop(t);
      await _settle(t, 800);
    }

    await _step(t, 'settings', () async {
      await t.tap(find.byWidgetPredicate(
          (Widget w) => w is PeshatIcon && identical(w.icon, AppIcons.settings)).first);
      await _settle(t);
      expect(find.text('Settings'), findsWidgets);
      _size(t, 'settings screen title', find.text('Settings'));
      await t.drag(find.byType(CustomScrollView).first, const Offset(0, -600));
      await _settle(t);
      await t.drag(find.byType(CustomScrollView).first, const Offset(0, -900));
      await _settle(t);
    });

    _log('PROBLEM COUNT ${_problems.length}');
    for (final String p in _problems) {
      _log('SUMMARY $p');
    }
    expect(_problems, isEmpty);
  });
}
