import 'package:flutter/material.dart';

/// Domain layer service for color manipulation operations.
class ColorService {
  /// Singleton instance for accessing color manipulation logic.
  static const ColorService _instance = ColorService._internal();

  /// Default amount for lightness adjustment.
  static const double defaultAmount = 0.1;
  factory ColorService() => _instance;

  const ColorService._internal();

  /// Adjusts the lightness of a color.
  ///
  /// [color]: The input color to adjust.
  /// [amount]: The amount to adjust lightness (between 0.0 and 1.0).
  /// [darken]: If true, decreases lightness; if false, increases lightness.
  /// Returns the adjusted color.
  Color adjustLightness({
    required Color color,
    double amount = defaultAmount,
    bool darken = false,
  }) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final newLightness =
        darken
            ? (hsl.lightness - amount).clamp(0.0, 1.0)
            : (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// Gets a contrasting text color (white or black) for readability.
  ///
  /// Returns white for dark colors, black for light colors.
  Color getContrastText(Color color) =>
      isDark(color) ? Colors.white : Colors.black;

  /// Determines if a color is dark based on its luminance.
  ///
  /// Returns true if the luminance is less than 0.5.
  bool isDark(Color color) => color.computeLuminance() < 0.5;

  /// Determines if a color is light based on its luminance.
  ///
  /// Returns true if the luminance is at least 0.5.
  bool isLight(Color color) => !isDark(color);

  /// Converts a color to a hex string.
  ///
  /// [color]: The input color.
  /// [withHashSign]: If true, includes '#' prefix (default: true).
  /// Returns the hex string (e.g., '#FF5500' or 'FF5500').
  String toHex(Color color, {bool withHashSign = true}) {
    final hexString =
        color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return withHashSign ? '#$hexString' : hexString;
  }

  /// Creates a color with the specified opacity.
  ///
  /// [color]: The input color.
  /// [opacity]: The opacity value (between 0.0 and 1.0).
  /// Returns the color with the adjusted opacity.
  Color withAlphaOpacity(Color color, double opacity) {
    assert(opacity >= 0 && opacity <= 1, 'Opacity must be between 0 and 1');
    return color.withAlpha((opacity * 255).round());
  }
}
