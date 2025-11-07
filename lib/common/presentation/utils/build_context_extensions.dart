import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/ui_colors.dart';
import 'package:zachranobed/l10n/app_localizations.dart';

/// An extension on [BuildContext] that provides convenient access to the [AppLocalizations] instance.
extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance associated with the current
  /// [BuildContext].
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

/// An extension on [BuildContext] that provides convenient access to various  theme-related properties from the
/// current [ThemeData].
extension AppThemeX on BuildContext {
  /// Returns the custom [UiColors] extension from the current theme.
  UiColors get uiColors => Theme.of(this).extension<UiColors>()!;

  /// Returns the [TextTheme] from the current theme.
  TextTheme get textTheme => Theme.of(this).textTheme;
}
