import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_shader_mask.dart';

/// A widget that displays a [text] with a [gradient] applied to it.
class UiGradientText extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The style to use for the text.
  final TextStyle style;

  /// The gradient to apply to the text.
  final Gradient gradient;

  /// Creates a new [UiGradientText].
  const UiGradientText({
    super.key,
    required this.text,
    required this.gradient,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    final hasUnderline = style.decoration == TextDecoration.underline;

    return UiGradientShaderMask(
      gradient: gradient,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IntrinsicWidth(
            child: Text(
              text,
              style: style.copyWith(
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (hasUnderline)
            Positioned(
              width: null,
              left: 0,
              right: 0,
              child: Container(
                height: 1.0,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
