import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/ui_colors.dart';
import 'package:zachranobed/common/presentation/utils/ui_text_styles.dart';
import 'package:zachranobed/l10n/app_localizations.dart';

/// An extension on [BuildContext] that provides convenient access to the [AppLocalizations] instance.
extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance associated with the current
  /// [BuildContext].
  ///
  /// Throws if localizations are not properly configured.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// An extension on [BuildContext] that provides convenient access to various  theme-related properties from the
/// current [ThemeData].
extension AppThemeX on BuildContext {
  /// Returns the custom [UiColors] extension from the current theme.
  UiColors get uiColors => Theme.of(this).extension<UiColors>()!;

  /// Returns a [UiTextStyles] wrapper that provides non-nullable access
  /// to text styles from the current theme.
  UiTextStyles get textStyles => UiTextStyles(Theme.of(this).textTheme);
}
