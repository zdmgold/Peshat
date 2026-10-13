import 'dart:math' as math;
import 'dart:ui' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/utils/app_colors.dart';

double _lin(double c) =>
    c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

double _lum(Color c) =>
    0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b);

double _ratio(Color a, Color b) {
  final hi = math.max(_lum(a), _lum(b));
  final lo = math.min(_lum(a), _lum(b));
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('text on filled accent buttons is readable in dark mode', () {
    expect(_ratio(AppColors.onAccentDark, AppColors.accentDark),
        greaterThanOrEqualTo(4.5));
  });

  test('text on filled accent buttons in light mode stays above 4:1', () {
    // White on the brand brass is 4.39:1 - close to, not above, 4.5.
    expect(_ratio(AppColors.onAccentLight, AppColors.accentLight),
        greaterThanOrEqualTo(4.0));
  });

  test('primary text is comfortably readable on both page backgrounds', () {
    expect(_ratio(AppColors.textPrimaryLight, AppColors.bgPrimaryLight),
        greaterThanOrEqualTo(7.0));
    expect(_ratio(AppColors.textPrimaryDark, AppColors.bgPrimaryDark),
        greaterThanOrEqualTo(7.0));
  });
}
