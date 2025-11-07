import 'package:flutter/material.dart';

/// Defines default size of a button.
class UiButtonSize {
  /// The height of a large button.
  static const _heightLarge = 50.0;

  /// The height of a medium button.
  static const _heightMedium = 40.0;

  /// The minimum width of a button.
  static const _minWidth = 150.0;

  static const largeWrapContent = Size(0.0, _heightLarge);
  static const largeMinWidth = Size(_minWidth, _heightLarge);
  static const largeMatchParent = Size(double.infinity, _heightLarge);
  static const mediumWrapContent = Size(0.0, _heightMedium);
  static const mediumMinWidth = Size(_minWidth, _heightMedium);
  static const mediumMatchParent = Size(double.infinity, _heightMedium);

  /// Private constructor to prevent instantiation.
  UiButtonSize._();

  /// Returns a size for large (default) button.
  ///
  /// The [fullWidth] parameter determines whether the button should match
  /// parent widget width.
  static Size? large({bool fullWidth = true}) {
    return fullWidth ? largeMatchParent : largeMinWidth;
  }

  /// Returns a size for medium button.
  ///
  /// The [fullWidth] parameter determines whether the button should match
  /// parent widget width.
  static Size? medium({bool fullWidth = true}) {
    return fullWidth ? mediumMatchParent : mediumMinWidth;
  }

  /// Returns a size for tiny button. Tiny button has no minimal size, so
  /// this method just returns null to use [Button] default behavior.
  static Size? tiny() {
    return null;
  }
}
