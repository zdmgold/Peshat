import 'package:flutter/widgets.dart';

/// Height of a row in the language pickers, which have fixed row heights so
/// the A-Z index can jump to a letter. The row grows with the text size, and
/// more for the interface languages whose scripts have tall lines. Measured
/// on the emulator with real fonts (needed height = 16 + factor x text
/// scale): Arabic, Persian and Urdu about 51, Lao 49, Sinhala 63, Burmese 70;
/// the other languages fit the base factor.
double pickerRowExtent(BuildContext context,
    {required double baseFactor, required double minimum}) {
  final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
  final tall = _tallLineFactor[Localizations.localeOf(context).languageCode];
  final factor = tall != null && tall > baseFactor ? tall : baseFactor;
  final extent = 16 + factor * scale;
  return extent > minimum ? extent : minimum;
}

const _tallLineFactor = <String, double>{
  'ar': 52,
  'fa': 52,
  'ur': 52,
  'lo': 50,
  'si': 63,
  'my': 70,
};
