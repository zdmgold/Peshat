import 'package:flutter/widgets.dart';

/// Gives a tappable child a small press-down scale.
///
/// Uses a raw pointer listener, so it never takes part in gesture
/// competition and the child's own tap handling is unchanged.
class PressScale extends StatefulWidget {
  final Widget child;
  final double scale;

  const PressScale({super.key, required this.child, this.scale = 0.96});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
