import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';

/// An icon button widget with gradient or solid color support.
///
/// Use [UiIconButton.gradient] for an icon with horizontal gradient.
/// Use [UiIconButton.solid] for an icon with solid color.
class UiIconButton extends StatefulWidget {
  /// The icon to display on the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the button is enabled or not.
  final bool enabled;

  /// Internal: solid color for the icon.
  final Color? _color;

  /// Internal: whether this is a gradient button.
  final bool _isGradient;

  /// Creates an icon button with horizontal gradient.
  const UiIconButton.gradient({
    super.key,
    required this.onPressed,
    required this.icon,
    this.enabled = true,
  }) : _color = null,
       _isGradient = true;

  /// Creates an icon button with solid color.
  ///
  /// If [color] is not provided, defaults to [UiColors.textPrimary].
  /// Hover color is automatically derived from the icon color.
  const UiIconButton.solid({
    super.key,
    required this.onPressed,
    required this.icon,
    Color? color,
    this.enabled = true,
  }) : _color = color,
       _isGradient = false;

  @override
  State<UiIconButton> createState() => _UiIconButtonState();
}

class _UiIconButtonState extends State<UiIconButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Gradient? foregroundGradient;
    Color? foregroundColor;
    Color? baseColorForHover;

    // Determine color/gradient based on mode
    if (widget._isGradient) {
      // Gradient mode
      baseColorForHover = context.uiColors.primary;
      if (!widget.enabled) {
        foregroundColor = context.uiColors.inactive;
      } else if (_isHovering) {
        foregroundGradient = context.uiColors.primaryGradientDark;
      } else {
        foregroundGradient = context.uiColors.primaryGradient;
      }
    } else {
      // Solid color mode
      baseColorForHover = widget._color ?? context.uiColors.textPrimary;
      if (!widget.enabled) {
        foregroundColor = context.uiColors.inactive;
      } else {
        foregroundColor = widget._color ?? context.uiColors.textPrimary;
      }
    }

    final style = IconButton.styleFrom(
      backgroundColor: context.uiColors.transparent,
      hoverColor: baseColorForHover.withValues(alpha: 0.1),
      highlightColor: baseColorForHover.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      minimumSize: const Size(40.0, 40.0),
      elevation: 0.0,
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
        style: style,
        onPressed: widget.enabled ? widget.onPressed : null,
        onHover: (isHovering) {
          setState(() => _isHovering = isHovering);
        },
        icon: UiGradientIcon(
          spec: UiIconSpec.data(widget.icon),
          color: foregroundColor,
          gradient: foregroundGradient,
        ),
      ),
    );
  }
}
