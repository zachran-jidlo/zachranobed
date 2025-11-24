import 'package:flutter/material.dart';

/// A class that holds custom color palette for the application.
class UiColors extends ThemeExtension<UiColors> {
  final Color primary;
  final Color primaryDark;
  final Gradient primaryGradient;
  final Gradient primaryGradientDark;

  final Color surfaceGray;
  final Color surfaceGrayDark;
  final Color surfaceWhite;

  final Color textPrimary;
  final Color textPrimaryInverse;
  final Color textSecondary;

  final Color success;
  final Color warning;
  final Color error;

  final Color inactive;

  final Color transparent;

  /// Creates a [UiColors] object.
  const UiColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryGradient,
    required this.primaryGradientDark,
    required this.surfaceGray,
    required this.surfaceGrayDark,
    required this.surfaceWhite,
    required this.textPrimary,
    required this.textPrimaryInverse,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.inactive,
    required this.transparent,
  });

  /// The light theme color palette.
  static const light = UiColors(
    primary: Color(0xFFC00016),
    primaryDark: Color(0xFF93000E),
    primaryGradient: LinearGradient(
      colors: [
        Color(0xFFC00016),
        Color(0xFF5A000A),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    primaryGradientDark: LinearGradient(
      colors: [
        Color(0xFF8E0010),
        Color(0xFF310006),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    surfaceGray: Color(0xFFF6F6F6),
    surfaceGrayDark: Color(0xFFE0E0E0),
    surfaceWhite: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF333333),
    textPrimaryInverse: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF858585),
    success: Color(0xFF009F08),
    warning: Color(0xFFF56905),
    error: Color(0xFFBA1A1A),
    inactive: Color(0xFFBDBDBD),
    transparent: Color(0x00000000),
  );

  @override
  UiColors copyWith({
    Color? primary,
    Color? primaryDark,
    Gradient? primaryGradient,
    Gradient? primaryGradientDark,
    Color? surfaceGray,
    Color? surfaceGrayDark,
    Color? surfaceWhite,
    Color? textPrimary,
    Color? textPrimaryInverse,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
    Color? inactive,
    Color? transparent,
  }) {
    return UiColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      primaryGradientDark: primaryGradientDark ?? this.primaryGradientDark,
      surfaceGray: surfaceGray ?? this.surfaceGray,
      surfaceGrayDark: surfaceGrayDark ?? this.surfaceGrayDark,
      surfaceWhite: surfaceWhite ?? this.surfaceWhite,
      textPrimary: textPrimary ?? this.textPrimary,
      textPrimaryInverse: textPrimaryInverse ?? this.textPrimaryInverse,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      inactive: inactive ?? this.inactive,
      transparent: transparent ?? this.transparent,
    );
  }

  @override
  UiColors lerp(ThemeExtension<UiColors>? other, double t) {
    if (other is! UiColors) return this;

    return UiColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryGradient: Gradient.lerp(primaryGradient, other.primaryGradient, t)!,
      primaryGradientDark: Gradient.lerp(primaryGradientDark, other.primaryGradientDark, t)!,
      surfaceGray: Color.lerp(surfaceGray, other.surfaceGray, t)!,
      surfaceGrayDark: Color.lerp(surfaceGrayDark, other.surfaceGrayDark, t)!,
      surfaceWhite: Color.lerp(surfaceWhite, other.surfaceWhite, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textPrimaryInverse: Color.lerp(textPrimaryInverse, other.textPrimaryInverse, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      inactive: Color.lerp(inactive, other.inactive, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }
}
