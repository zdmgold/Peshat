import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/widgets/alpha_index.dart';

void main() {
  testWidgets('tapping a letter in the rail scrolls to that section',
      (tester) async {
    final entries = <IndexEntry>[
      for (final letter in ['A', 'B', 'C']) ...[
        IndexEntry(
          extent: 32,
          letter: letter,
          child: Text('header $letter'),
        ),
        for (var i = 0; i < 20; i++)
          IndexEntry(extent: 64, child: Text('$letter row $i')),
      ],
    ];

    await tester.pumpWidget(
      CupertinoApp(
        home: SizedBox(
          height: 600,
          child: AlphaIndexedList(
            entries: entries,
            letterColor: const Color(0xFF9C7038),
          ),
        ),
      ),
    );

    expect(find.text('C row 0'), findsNothing);

    // The rail shows one tappable cell per letter; tap the "C" cell.
    await tester.tap(find.text('C').first);
    await tester.pumpAndSettle();

    expect(find.text('header C'), findsOneWidget);
    expect(find.text('A row 0'), findsNothing);
  });
}
