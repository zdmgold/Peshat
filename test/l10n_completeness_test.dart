import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all ARB files have the same key set as app_en.arb', () {
    final l10nDir = Directory('lib/l10n');
    expect(l10nDir.existsSync(), isTrue, reason: 'lib/l10n/ not found');

    final template = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;

    final templateKeys =
        template.keys.where((k) => !k.startsWith('@')).toSet();

    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .where((f) => !f.path.endsWith('app_en.arb'))
        .toList();

    expect(arbFiles, isNotEmpty, reason: 'no ARB files besides app_en.arb');

    final failures = <String>[];
    for (final file in arbFiles) {
      final locale = file.uri.pathSegments.last
          .replaceFirst('app_', '')
          .replaceFirst('.arb', '');
      final data =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final keys = data.keys.where((k) => !k.startsWith('@')).toSet();

      final missing = templateKeys.difference(keys);
      final extra = keys.difference(templateKeys);
      if (missing.isNotEmpty) {
        failures.add('$locale missing: ${missing.join(", ")}');
      }
      if (extra.isNotEmpty) {
        failures.add('$locale has extra: ${extra.join(", ")}');
      }
    }

    expect(
      failures,
      isEmpty,
      reason: 'ARB files out of sync with app_en.arb:\n${failures.join("\n")}',
    );
  });
}
