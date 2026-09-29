import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get chrome => GoogleFonts.inter();
  static TextStyle get body => GoogleFonts.merriweather();
  static TextStyle get sourceChip => GoogleFonts.robotoMono();

  /// Brand display face — used only for the "Peshat" wordmark
  /// (AppBar title + hero). Fraunces is a soft editorial serif that
  /// sits alongside Merriweather (body serif) without competing.
  static TextStyle get brand => GoogleFonts.fraunces(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.05,
      );
}
