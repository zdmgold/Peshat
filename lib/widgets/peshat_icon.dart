import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/utils/app_icons.dart';

/// App-wide icon widget.
///
/// Thin wrapper over [HugeIcon] that fixes the stroke weight to a
/// consistent value so icons read with the visual density of modern
/// iOS SF Symbols (Semibold), not the thin default of Hugeicons'
/// Stroke Rounded set.
///
/// Every screen uses [PeshatIcon]. Swapping icon sets later touches this
/// file and [AppIcons], nothing else.
class PeshatIcon extends StatelessWidget {
  final List<List<dynamic>> icon;
  final double size;
  final Color? color;
  final double strokeWidth;

  const PeshatIcon({
    super.key,
    required this.icon,
    this.size = 22,
    this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      size: size,
      color: color,
      strokeWidth: strokeWidth,
    );
  }
}

/// Override for [CupertinoNavigationBar.leading] on pushed screens.
///
/// Replaces Flutter's built-in back button, which ships as an icon from
/// the deprecated iOS icon set, with a HugeIcon chevron that matches the
/// from the `cupertino_icons` package we no longer depend on — with a
/// [PeshatIcon] chevron that matches the rest of the app.
Widget peshatBackButton(BuildContext context, {Color? color}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    minSize: 44,
    onPressed: () => Navigator.of(context).maybePop(),
    child: PeshatIcon(
      icon: AppIcons.chevronBack,
      size: 22,
      color: color,
    ),
  );
}
