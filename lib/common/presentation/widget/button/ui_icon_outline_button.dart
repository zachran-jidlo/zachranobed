import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// An outlined icon button widget.
class UiIconOutlineButton extends StatefulWidget {
  /// The icon to display on the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the button is enabled or not.
  final bool enabled;

  /// Creates a new [UiIconOutlineButton].
  const UiIconOutlineButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.enabled = true,
  });

  @override
  State<UiIconOutlineButton> createState() => _UiIconOutlineButtonState();
}

class _UiIconOutlineButtonState extends State<UiIconOutlineButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final style = IconButton.styleFrom(
      backgroundColor: context.uiColors.transparent,
      hoverColor: context.uiColors.primary.withValues(alpha: 0.1),
      highlightColor: context.uiColors.primary.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      minimumSize: Size(40.0, 40.0),
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

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) => getShader(bounds, foregroundColor, foregroundGradient),
              blendMode: BlendMode.srcIn,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            style: style,
            onPressed: widget.enabled ? widget.onPressed : null,
            onHover: (isHovering) {
              setState(() => _isHovering = isHovering);
            },
            icon: ShaderMask(
              shaderCallback: (bounds) => getShader(bounds, foregroundColor, foregroundGradient),
              blendMode: BlendMode.srcIn,
              child: Icon(
                widget.icon,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Shader getShader(Rect bounds, Color? color, Gradient? gradient) {
    if (gradient != null) {
      return gradient.createShader(bounds);
    } else if (color != null) {
      return LinearGradient(
        colors: [color, color],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds);
    } else {
      throw Exception('No gradient or color provided');
    }
  }
}
