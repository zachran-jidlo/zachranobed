import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_text.dart';

/// A text button widget.
class UiTextButton extends StatefulWidget {
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

  /// Creates a new [UiTextButton].
  const UiTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.enabled = true,
  });

  @override
  State<UiTextButton> createState() => _UiTextButtonState();
}

class _UiTextButtonState extends State<UiTextButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      minimumSize: widget.size,
      shape: const StadiumBorder(),
      elevation: 0.0,
    );

    return TextButton.icon(
      style: style,
      onPressed: widget.enabled ? widget.onPressed : null,
      onHover: (isHovering) {
        setState(() => _isHovering = isHovering);
      },
      icon: _icon(),
      iconAlignment: widget.iconAlignment,
      label: _label(),
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
      color: color,
      size: 18.0,
    );
  }

  Widget _label() {
    final style = _resolveTextStyle();
    if (!widget.enabled) {
      return Text(
        widget.text,
        style: style,
      );
    }

    Gradient? gradient = context.uiColors.primaryGradient;
    if (_isHovering) {
      gradient =  context.uiColors.primaryGradientDark;
    }

    return UiGradientText(
      text: widget.text,
      gradient: gradient,
      style: style,
    );
  }

  TextStyle _resolveTextStyle() {
    final style = context.textStyles.labelLarge;

    TextDecoration? decoration;
    if (_isHovering) {
      decoration = TextDecoration.underline;
    }

    Color? color;
    if (!widget.enabled) {
      color = context.uiColors.inactive;
    }

    return style.copyWith(
      decoration: decoration,
      color: color,
    );
  }
}
