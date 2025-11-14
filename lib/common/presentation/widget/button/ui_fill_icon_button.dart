import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A filled icon button widget.
class UiIconFillButton extends StatefulWidget {
  /// The icon to display on the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the button is enabled or not.
  final bool enabled;

  /// Creates a new [UiIconFillButton].
  const UiIconFillButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.enabled = true,
  });

  @override
  State<UiIconFillButton> createState() => _UiIconFillButtonState();
}

class _UiIconFillButtonState extends State<UiIconFillButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = IconButton.styleFrom(
      foregroundColor: context.uiColors.surfaceWhite,
      disabledForegroundColor: context.uiColors.surfaceWhite,
      backgroundColor: context.uiColors.transparent,
      shadowColor: context.uiColors.transparent,
      minimumSize: Size(40.0, 40.0),
      shape: const CircleBorder(),
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

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: IconButton(
          style: style,
          onPressed: widget.enabled ? widget.onPressed : null,
          onHover: (isHovering) {
            setState(() => _isHovering = isHovering);
          },
          icon: Icon(widget.icon),
        ),
      ),
    );
  }
}
