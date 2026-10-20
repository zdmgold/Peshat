// Typed translation for every supported language: language -> English with the
// true source, English -> language, and the round trip back to English.
// Logs "TX" lines; nothing here fails.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:peshat/core/services/translator_service.dart';

import 'latin_samples.dart';
import 'samples.dart';

void _log(String m) => debugPrint('EMU ${DateTime.now().toIso8601String()} $m');

const String _en = 'Good morning, how are you today?';

const Map<String, List<List<int>>> _ranges = <String, List<List<int>>>{
  'ru': <List<int>>[<int>[0x400, 0x4FF]], 'uk': <List<int>>[<int>[0x400, 0x4FF]],
  'bg': <List<int>>[<int>[0x400, 0x4FF]], 'be': <List<int>>[<int>[0x400, 0x4FF]],
  'mk': <List<int>>[<int>[0x400, 0x4FF]], 'el': <List<int>>[<int>[0x370, 0x3FF]],
  'ar': <List<int>>[<int>[0x600, 0x6FF], <int>[0xFB50, 0xFEFF]],
  'fa': <List<int>>[<int>[0x600, 0x6FF], <int>[0xFB50, 0xFEFF]],
  'ur': <List<int>>[<int>[0x600, 0x6FF], <int>[0xFB50, 0xFEFF]],
  'he': <List<int>>[<int>[0x590, 0x5FF]], 'th': <List<int>>[<int>[0xE00, 0xE7F]],
  'hi': <List<int>>[<int>[0x900, 0x97F]], 'mr': <List<int>>[<int>[0x900, 0x97F]],
  'bn': <List<int>>[<int>[0x980, 0x9FF]], 'gu': <List<int>>[<int>[0xA80, 0xAFF]],
  'kn': <List<int>>[<int>[0xC80, 0xCFF]], 'ta': <List<int>>[<int>[0xB80, 0xBFF]],
  'te': <List<int>>[<int>[0xC00, 0xC7F]], 'ka': <List<int>>[<int>[0x10A0, 0x10FF]],
  'zh': <List<int>>[<int>[0x4E00, 0x9FFF]],
  'ja': <List<int>>[<int>[0x3040, 0x30FF], <int>[0x4E00, 0x9FFF]],
  'ko': <List<int>>[<int>[0xAC00, 0xD7AF]],
};

final RegExp _letter = RegExp(r'\p{L}', unicode: true);

String _scriptCheck(String code, String text) {
  final List<List<int>>? r = _ranges[code];
  final List<int> letters = text.runes
      .where((int c) => _letter.hasMatch(String.fromCharCode(c)))
      .toList();
  if (letters.isEmpty) return 'EMPTY';
  final int inRange = letters
      .where((int c) => r == null
          ? (c < 0x250 || (c >= 0x1E00 && c <= 0x1EFF))
          : r.any((List<int> x) => c >= x[0] && c <= x[1]))
      .length;
  return inRange / letters.length >= 0.6 ? 'script-ok' : 'SCRIPT-WRONG';
}

Set<String> _words(String s) => s
    .toLowerCase()
    .split(RegExp(r'[^a-z0-9]+'))
    .where((String w) => w.isNotEmpty)
    .toSet();

int _overlap(String a, String b) {
  final Set<String> x = _words(a), y = _words(b);
  if (x.isEmpty) return 0;
  return (100 * x.intersection(y).length / x.length).round();
}

Future<String> _tr(TranslatorService svc, String text, String from, String to) async {
  try {
    for (final String c in await svc.missingPacks(fromBcp: from, toBcp: to)) {
      await svc.receivePack(c).timeout(const Duration(seconds: 240));
    }
    return await svc
        .translate(text: text, fromBcp: from, toBcp: to)
        .timeout(const Duration(seconds: 90));
  } catch (e) {
    return 'ERROR($e)';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('translate every language both ways', (WidgetTester t) async {
    final TranslatorService svc = TranslatorService();
    final Map<String, String> sentence = <String, String>{
      for (final MapEntry<String, List<String>> e in kSamples.entries) e.key: e.value[1],
      for (final MapEntry<String, List<String>> e in kLatinSamples.entries) e.key: e.value[1],
    };
    for (final MapEntry<String, String> e in sentence.entries) {
      final String code = e.key;
      if (code == 'en') continue;
      final String toEn = await _tr(svc, e.value, code, 'en');
      _log('TX $code ->en overlap=${_overlap(_en, toEn)} "$toEn"');
      final String fromEn = await _tr(svc, _en, 'en', code);
      final String check = _scriptCheck(code, fromEn);
      final String back = await _tr(svc, fromEn, code, 'en');
      _log('TX en->$code $check roundtrip=${_overlap(_en, back)} "$fromEn" back="$back"');
    }
  });
}
