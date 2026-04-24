import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/ui_colors.dart';

/// A wrapper class that provides non-nullable access to [TextStyle] properties from [TextTheme].
///
/// All text style getters return a non-null [TextStyle], defaulting to an empty [TextStyle]
/// if the corresponding style in the theme is null.
class UiTextStyles {
  final TextTheme _theme;

  UiTextStyles(this._theme);

  TextStyle get displayLarge => _theme.displayLarge ?? const TextStyle();
  TextStyle get displayMedium => _theme.displayMedium ?? const TextStyle();
  TextStyle get displaySmall => _theme.displaySmall ?? const TextStyle();

  TextStyle get headlineHeavy => headlineLarge.copyWith(fontFamily: 'FuturaBold');
  TextStyle get headlineLarge => _theme.headlineLarge ?? const TextStyle();
  TextStyle get headlineMedium => _theme.headlineMedium ?? const TextStyle();
  TextStyle get headlineSmall => _theme.headlineSmall ?? const TextStyle();

  TextStyle get titleHeavy => titleLarge.copyWith(fontFamily: 'FuturaBold');
  TextStyle get titleLarge => _theme.titleLarge ?? const TextStyle();
  TextStyle get titleMedium => _theme.titleMedium ?? const TextStyle();
  TextStyle get titleSmall => _theme.titleSmall ?? const TextStyle();

  TextStyle get bodyLarge => _theme.bodyLarge ?? const TextStyle();
  TextStyle get bodyMedium => _theme.bodyMedium ?? const TextStyle();
  TextStyle get bodySmall => _theme.bodySmall ?? const TextStyle();

  TextStyle get labelLarge => _theme.labelLarge ?? const TextStyle();
  TextStyle get labelMedium => _theme.labelMedium ?? const TextStyle();
  TextStyle get labelSmall => _theme.labelSmall ?? const TextStyle();

  static TextTheme getTextTheme() {
    return Typography.material2021().black.copyWith(
          // Display
          displayLarge: TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 57,
            height: 64.0 / 57.0,
            letterSpacing: 0,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 45,
            height: 52.0 / 45.0,
            letterSpacing: 0,
          ),
          displaySmall: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 36,
            height: 44.0 / 36.0,
            letterSpacing: 0,
          ),
          // Headline
          headlineLarge: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 32,
            height: 40.0 / 32.0,
            letterSpacing: 0,
          ),
          headlineMedium: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 28,
            height: 36.0 / 28.0,
            letterSpacing: 0,
          ),
          headlineSmall: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 24,
            height: 32.0 / 24.0,
            letterSpacing: 0,
          ),
          // Title
          titleLarge: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 22,
            height: 28.0 / 22.0,
            letterSpacing: 0,
          ),
          titleMedium: const TextStyle(
            fontFamily: 'FuturaSemiBold',
            fontSize: 16,
            height: 24.0 / 16.0,
            letterSpacing: 0.15,
          ),
          titleSmall: const TextStyle(
            fontFamily: 'FuturaMedium',
            fontSize: 14,
            height: 20.0 / 14.0,
            letterSpacing: 0.1,
          ),
          // Body
          bodyLarge: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            height: 24.0 / 16.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            height: 20.0 / 14.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            height: 16.0 / 12.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          // Label
          labelLarge: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            height: 20.0 / 14.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          labelMedium: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            height: 16.0 / 12.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          labelSmall: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11,
            height: 16.0 / 11.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        )
        .apply(
          // Context is not available here, so we must hardcode UiColors.light
          bodyColor: UiColors.light.textPrimary,
          displayColor: UiColors.light.textPrimary,
        );
  }
}
