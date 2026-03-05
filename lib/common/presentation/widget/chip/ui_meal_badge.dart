import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';

/// A badge widget for displaying meal metadata (type, allergens, expiry, etc.).
///
/// Displays an icon followed by a label, typically used within [UiMealTile].
class UiMealBadge extends StatelessWidget {
  /// The icon to display.
  final UiIconSpec icon;

  /// The text label.
  final String label;

  /// Creates a [UiMealBadge].
  const UiMealBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.0,
      children: [
        UiGradientIcon(
          spec: icon,
          size: 24,
          gradient: context.uiColors.primaryGradient,
        ),
        Text(
          label,
          style: context.textStyles.labelSmall.copyWith(
            color: context.uiColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
