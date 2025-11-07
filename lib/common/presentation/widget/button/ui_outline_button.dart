import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// An outlined button widget.
class UiOutlineButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// The icon to display on the button.
  final IconData? icon;

  /// The alignment of the icon.
  final IconAlignment iconAlignment;

  /// The size of the button.
  final Size? size;

  /// Whether the button is enabled or not.
  final bool enabled;

  /// Creates a new [UiOutlineButton].
  const UiOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      backgroundColor: context.uiColors.transparent,
      shape: StadiumBorder(),
      minimumSize: size,
      elevation: 0.0,
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: context.uiColors.inactive);
          }
          return BorderSide(color: context.uiColors.primary);
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return context.uiColors.inactive;
          }
          return context.uiColors.primary;
        },
      ),
    );

    return OutlinedButton.icon(
      style: style,
      onPressed: enabled ? onPressed : null,
      icon: _icon(),
      iconAlignment: iconAlignment,
      label: Text(text),
    );
  }

  Widget? _icon() {
    if (icon == null) {
      return null;
    }

    return Icon(
      icon,
      size: 18.0,
    );
  }
}
