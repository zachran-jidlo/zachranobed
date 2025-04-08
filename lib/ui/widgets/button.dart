import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZOButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ZOButtonType type;
  final IconData? icon;
  final IconAlignment? iconAlignment;
  final Size? minimumSize;
  final bool enabled;

  const ZOButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ZOButtonType.primary,
    this.icon,
    this.iconAlignment,
    this.minimumSize = ZOButtonSize.largeMatchParent,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      foregroundColor: type.foregroundColor,
      backgroundColor: type.backgroundColor,
      minimumSize: minimumSize,
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: FontSize.xs),
      elevation: 0.0,
      side: BorderSide(width: 1, color: type.outlineColor),
    );

    if (type.outlineColor != Colors.transparent) {
      if (icon != null) {
        return OutlinedButton.icon(
          style: style,
          onPressed: enabled ? onPressed : null,
          icon: Icon(
            icon,
            size: 18.0,
          ),
          iconAlignment: iconAlignment ?? IconAlignment.start,
          label: Text(text),
        );
      } else {
        return OutlinedButton(
          style: style,
          onPressed: enabled ? onPressed : null,
          child: Text(text),
        );
      }
    }

    if (type.backgroundColor != Colors.transparent) {
      if (icon != null) {
        return ElevatedButton.icon(
          style: style,
          onPressed: enabled ? onPressed : null,
          icon: Icon(
            icon,
            size: 18.0,
          ),
          iconAlignment: iconAlignment ?? IconAlignment.start,
          label: Text(text),
        );
      } else {
        return ElevatedButton(
          style: style,
          onPressed: enabled ? onPressed : null,
          child: Text(text),
        );
      }
    }

    if (icon != null) {
      return TextButton.icon(
        style: style,
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 18.0,
        ),
        iconAlignment: iconAlignment ?? IconAlignment.start,
        label: Text(text),
      );
    } else {
      return TextButton(
        style: style,
        onPressed: enabled ? onPressed : null,
        child: Text(text),
      );
    }
  }
}

enum ZOButtonType {
  primary(ZOColors.primary, ZOColors.onPrimary, Colors.transparent),
  secondary(ZOColors.secondary, ZOColors.onSecondary, Colors.transparent),
  tertiary(Colors.transparent, ZOColors.primary, ZOColors.outline),
  success(ZOColors.success, ZOColors.onSuccess, Colors.transparent),
  text(Colors.transparent, ZOColors.onPrimaryLight, Colors.transparent),
  textPrimary(Colors.transparent, ZOColors.primary, Colors.transparent);

  const ZOButtonType(
    this.backgroundColor,
    this.foregroundColor,
    this.outlineColor,
  );

  final Color backgroundColor;
  final Color foregroundColor;
  final Color outlineColor;
}

/// Defines default size of a [ZOButton].
class ZOButtonSize {
  /// The height of a large button.
  static const _heightLarge = 56.0;

  /// The height of a medium button.
  static const _heightMedium = 40.0;

  /// The minimum width of a button.
  static const _minWidth = 180.0;

  static const largeWrapContent = Size(0.0, _heightLarge);
  static const largeMinWidth = Size(_minWidth, _heightLarge);
  static const largeMatchParent = Size(double.infinity, _heightLarge);
  static const mediumWrapContent = Size(0.0, _heightMedium);
  static const mediumMinWidth = Size(_minWidth, _heightMedium);
  static const mediumMatchParent = Size(double.infinity, _heightMedium);

  /// Private constructor to prevent instantiation.
  ZOButtonSize._();

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

/// Defines the possible width behaviors for a [ZOButton].
enum ZOButtonWidth {
  /// The button's width will be determined by the size of its content.
  wrapContent,

  /// The button will have a minimum width (see [ZOButtonSize._minWidth]).
  /// The content may cause it to be wider than this minimum.
  minWidth,

  /// The button will expand to fill the width of its parent container.
  matchParent,
}
