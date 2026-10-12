import 'package:flutter/cupertino.dart';
import '../core/utils/app_typography.dart';
import '../core/utils/spacing.dart';

/// One entry in an [AlphaIndexedList]. [extent] is the fixed height of the
/// entry; [letter] marks the entry as the start of that letter's section.
class IndexEntry {
  final double extent;
  final String? letter;
  final Widget child;
  const IndexEntry({required this.extent, required this.child, this.letter});
}

/// A scrolling list with an A-Z rail on the trailing edge. Every entry has a
/// fixed height, so a letter's scroll offset is just the sum of the heights
/// above it and no entry has to be built to find it.
class AlphaIndexedList extends StatefulWidget {
  final List<IndexEntry> entries;
  final Color letterColor;
  final bool showIndex;

  const AlphaIndexedList({
    super.key,
    required this.entries,
    required this.letterColor,
    this.showIndex = true,
  });

  @override
  State<AlphaIndexedList> createState() => _AlphaIndexedListState();
}

class _AlphaIndexedListState extends State<AlphaIndexedList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _jumpTo(String letter) {
    if (!_controller.hasClients) return;
    var offset = 0.0;
    for (final e in widget.entries) {
      if (e.letter == letter) break;
      offset += e.extent;
    }
    final max = _controller.position.maxScrollExtent;
    _controller.jumpTo(offset.clamp(0.0, max));
  }

  @override
  Widget build(BuildContext context) {
    final letters = [
      for (final e in widget.entries)
        if (e.letter != null) e.letter!,
    ];
    return Stack(
      children: [
        CustomScrollView(
          controller: _controller,
          slivers: [
            SliverVariedExtentList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => widget.entries[i].child,
                childCount: widget.entries.length,
              ),
              itemExtentBuilder: (i, _) => widget.entries[i].extent,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: Spacing.xl)),
          ],
        ),
        if (widget.showIndex && letters.length > 1)
          PositionedDirectional(
            end: 2,
            top: Spacing.sm,
            bottom: Spacing.sm,
            child: ExcludeSemantics(
              child: _IndexRail(
                letters: letters,
                color: widget.letterColor,
                onSelect: _jumpTo,
              ),
            ),
          ),
      ],
    );
  }
}

class _IndexRail extends StatelessWidget {
  final List<String> letters;
  final Color color;
  final ValueChanged<String> onSelect;

  const _IndexRail({
    required this.letters,
    required this.color,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = (constraints.maxHeight / letters.length).clamp(0.0, 18.0);
        void pick(double dy) {
          if (cell <= 0) return;
          final i = (dy / cell).floor().clamp(0, letters.length - 1);
          onSelect(letters[i]);
        }

        return Center(
          child: SizedBox(
            width: 24,
            height: cell * letters.length,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => pick(d.localPosition.dy),
              onVerticalDragStart: (d) => pick(d.localPosition.dy),
              onVerticalDragUpdate: (d) => pick(d.localPosition.dy),
              child: Column(
                children: [
                  for (final l in letters)
                    SizedBox(
                      height: cell,
                      child: Center(
                        child: Text(
                          l,
                          style: AppTypography.chrome.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
