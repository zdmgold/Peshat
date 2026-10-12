import 'package:flutter/widgets.dart';
import '../core/services/pdf_fonts.dart';

/// Text that follows its own content's direction rather than the app's.
///
/// Hebrew or Arabic text inside an English interface otherwise gets a
/// left-to-right base direction, which scrambles mixed lines and left-aligns
/// them. The box fills the available width so right-to-left text sits at the
/// right edge.
class AutoDirectionText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const AutoDirectionText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textDirection:
            PdfFonts.isMostlyRtl(text) ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }
}
