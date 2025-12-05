import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A primary button widget.
class UiPrimaryButton extends StatefulWidget {
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

  /// Creates a new [UiPrimaryButton].
  const UiPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.enabled = true,
  });

  @override
  State<UiPrimaryButton> createState() => _UiPrimaryButtonState();
}

class _UiPrimaryButtonState extends State<UiPrimaryButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      foregroundColor: context.uiColors.surfaceWhite,
      disabledForegroundColor: context.uiColors.surfaceWhite,
      backgroundColor: context.uiColors.transparent,
      shadowColor: context.uiColors.transparent,
      minimumSize: widget.size,
      shape: const StadiumBorder(),
      textStyle: context.textStyles.labelLarge,
      elevation: 0.0,
    );

    Gradient? backgroundGradient;
    Color? backgroundColor;
    if (!widget.enabled) {
      backgroundColor = context.uiColors.inactive;
    } else if (_isHovering) {
      backgroundGradient = context.uiColors.primaryGradientDark;
    } else {
      backgroundGradient = context.uiColors.primaryGradient;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: ElevatedButton.icon(
        style: style,
        onPressed: widget.enabled ? widget.onPressed : null,
        onHover: (isHovering) {
          setState(() => _isHovering = isHovering);
        },
        icon: _icon(),
        iconAlignment: widget.iconAlignment,
        label: Text(widget.text),
      ),
    );
  }

  Widget? _icon() {
    if (widget.icon == null) {
      return null;
    }

    return Icon(
      widget.icon,
      size: 18.0,
    );
  }
}
