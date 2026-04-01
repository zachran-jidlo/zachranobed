import 'package:flutter/widgets.dart';

/// A widget that applies a gradient or solid color shader mask to its child.
///
/// This widget wraps any child and applies either a provided [Gradient] or a solid [Color] as a shader using
/// [ShaderMask]. If both are provided, the [color] takes precedence.
class UiGradientShaderMask extends StatelessWidget {
  /// The widget to which the shader will be applied.
  final Widget child;

  /// Optional gradient used to create the shader.
  /// If [color] is provided, this is ignored.
  final Gradient? gradient;

  /// Optional solid color that creates a flat shader.
  /// Overrides [gradient] if provided.
  final Color? color;

  /// Creates a [UiGradientShaderMask] widget.
  const UiGradientShaderMask({
    super.key,
    required this.child,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => _getShader(bounds, color, gradient),
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }

  Shader _getShader(Rect bounds, Color? color, Gradient? gradient) {
    if (color != null) {
      return LinearGradient(
        colors: [color, color],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds);
    } else if (gradient != null) {
      return gradient.createShader(bounds);
    } else {
      throw Exception('No gradient or color provided');
    }
  }
}
