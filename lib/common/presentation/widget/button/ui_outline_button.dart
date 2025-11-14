import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_shader_mask.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_text.dart';

/// An outlined button widget.
class UiOutlineButton extends StatefulWidget {
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
  State<UiOutlineButton> createState() => _UiOutlineButtonState();
}

class _UiOutlineButtonState extends State<UiOutlineButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      backgroundColor: context.uiColors.transparent,
      side: BorderSide(style: BorderStyle.none),
      shape: StadiumBorder(),
      minimumSize: widget.size,
      elevation: 0.0,
    );

    Gradient? foregroundGradient;
    Color? foregroundColor;
    if (!widget.enabled) {
      foregroundColor = context.uiColors.inactive;
    } else if (_isHovering) {
      foregroundGradient = context.uiColors.primaryGradientDark;
    } else {
      foregroundGradient = context.uiColors.primaryGradient;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: UiGradientShaderMask(
            color: foregroundColor,
            gradient: foregroundGradient,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          style: style,
          onPressed: widget.enabled ? widget.onPressed : null,
          onHover: (isHovering) {
            setState(() => _isHovering = isHovering);
          },
          icon: _icon(),
          iconAlignment: widget.iconAlignment,
          label: _label(foregroundColor, foregroundGradient),
        ),
      ],
    );
  }

  Widget? _icon() {
    if (widget.icon == null) {
      return null;
    }

    Color color = context.uiColors.primary;
    if (!widget.enabled) {
      color = context.uiColors.inactive;
    }

    return Icon(
      widget.icon,
      size: 18.0,
      color: color,
    );
  }

  Widget _label(Color? color, Gradient? gradient) {
    final style = context.textTheme.labelLarge ?? const TextStyle();
    if (color != null) {
      return Text(
        widget.text,
        style: style.copyWith(color: color),
      );
    }

    if (gradient != null) {
      return UiGradientText(
        text: widget.text,
        gradient: gradient,
        style: style,
      );
    }

    throw Exception('No gradient or color provided');
  }
}
