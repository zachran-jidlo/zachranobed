import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A custom tooltip widget with a specific style and positioning.
///
/// This widget wraps the standard Flutter [Tooltip] and provides a
/// consistent look and feel for tooltips within the application.
class ZOTooltip extends StatelessWidget {
  /// The message to display in the tooltip.
  final String message;

  /// The child widget that triggers the tooltip when hovered.
  final Widget child;

  /// Creates a [ZOTooltip] widget.
  const ZOTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: message,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      verticalOffset: 40.0,
      decoration: BoxDecoration(
        color: ZOColors.infoSnackBarBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: ZOColors.disabledButtonChild,
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: -2,
          )
        ],
      ),
      child: child,
    );
  }
}
