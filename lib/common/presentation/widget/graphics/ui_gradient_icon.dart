import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_shader_mask.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';

/// A widget that renders an icon with a gradient or solid color applied via shader mask.
class UiGradientIcon extends StatelessWidget {
  /// The icon specification to render.
  final UiIconSpec spec;

  /// Optional size override for the icon.
  ///
  /// If not provided, falls back to the size from the current [IconTheme].
  final double? size;

  /// Optional gradient used to create the shader.
  /// If [color] is provided, this is ignored.
  final Gradient? gradient;

  /// Optional solid color that creates a flat shader.
  /// Overrides [gradient] if provided.
  final Color? color;

  /// Creates a [UiGradientIcon] widget.
  const UiGradientIcon({
    super.key,
    required this.spec,
    this.size,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return UiGradientShaderMask(
      gradient: gradient,
      color: color,
      child: UiIcon(
        spec: spec,
        size: size,
        color: Colors.black,
      ),
    );
  }
}
