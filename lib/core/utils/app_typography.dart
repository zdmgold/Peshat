import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Merriweather is an excellent, highly readable serif font for translated text
  static TextStyle get body => GoogleFonts.merriweather(
    fontSize: 18,
    height: 1.55,
  );

  // Roboto Mono is perfect for source code/chips
  static TextStyle get sourceChip => GoogleFonts.robotoMono(
    fontSize: 14,
  );
  
  // Roboto is the standard, clean sans-serif for UI chrome
  static TextStyle get chrome => GoogleFonts.roboto();
}
