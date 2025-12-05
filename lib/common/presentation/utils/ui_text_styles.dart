import 'package:flutter/material.dart';

/// A wrapper class that provides non-nullable access to [TextStyle] properties from [TextTheme].
///
/// All text style getters return a non-null [TextStyle], defaulting to an empty [TextStyle]
/// if the corresponding style in the theme is null.
class UiTextStyles {
  final TextTheme _theme;

  const UiTextStyles(this._theme);

  TextStyle get displayLarge => _theme.displayLarge ?? const TextStyle();
  TextStyle get displayMedium => _theme.displayMedium ?? const TextStyle();
  TextStyle get displaySmall => _theme.displaySmall ?? const TextStyle();

  TextStyle get headlineLarge => _theme.headlineLarge ?? const TextStyle();
  TextStyle get headlineMedium => _theme.headlineMedium ?? const TextStyle();
  TextStyle get headlineSmall => _theme.headlineSmall ?? const TextStyle();

  TextStyle get titleLarge => _theme.titleLarge ?? const TextStyle();
  TextStyle get titleMedium => _theme.titleMedium ?? const TextStyle();
  TextStyle get titleSmall => _theme.titleSmall ?? const TextStyle();

  TextStyle get bodyLarge => _theme.bodyLarge ?? const TextStyle();
  TextStyle get bodyMedium => _theme.bodyMedium ?? const TextStyle();
  TextStyle get bodySmall => _theme.bodySmall ?? const TextStyle();

  TextStyle get labelLarge => _theme.labelLarge ?? const TextStyle();
  TextStyle get labelMedium => _theme.labelMedium ?? const TextStyle();
  TextStyle get labelSmall => _theme.labelSmall ?? const TextStyle();
}
