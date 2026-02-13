import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom tooltip widget with a specific style and positioning.
///
/// This widget wraps the standard Flutter [Tooltip] and provides a
/// consistent look and feel for tooltips within the application.
class UiTooltip extends StatelessWidget {
  /// The message to display in the tooltip.
  final String message;

  /// The child widget that triggers the tooltip when hovered.
  final Widget child;

  /// Creates a [ZOTooltip] widget.
  const UiTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: message,
      textStyle: context.textStyles.bodySmall.copyWith(color: context.uiColors.textPrimaryInverse),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      verticalOffset: 40.0,
      decoration: BoxDecoration(
        color: context.uiColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
