import 'package:flutter/material.dart';

/// Extensions on [Color] for various utility operations
extension ColorExtension on Color {
  /// Get contrasting text color (white or black) based on
  /// this color's luminance
  Color get contrastText => isDark ? Colors.white : Colors.black;

  /// Check if this color is dark
  bool get isDark => computeLuminance() < 0.5;

  /// Check if this color is light
  bool get isLight => !isDark;

  /// Returns a darker version of this color.
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Returns a lighter version of this color.
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }

  /// Converts a [Color] to a hex string (e.g., '#FF5500').
  String toHex({bool withHashSign = true}) {
    final String hexString =
        value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return withHashSign ? '#$hexString'.substring(1) : hexString.substring(2);
  }

  /// Creates a version of this color with specific opacity.
  /// More intuitive than the default [withValues] method in some cases.
  Color withAlphaOpacity(double opacity) {
    return withAlpha((opacity * 255).round());
  }
}
