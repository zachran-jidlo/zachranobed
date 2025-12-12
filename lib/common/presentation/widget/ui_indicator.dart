import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a badge indicator over a child widget.
class UiIndicator extends StatelessWidget {
  /// Determines whether the badge indicator should be visible.
  final bool isVisible;

  /// The child widget that the badge is attached to.
  final Widget child;

  /// Offset for the badge position.
  /// The offset is applied from the top-right corner of the child.
  /// Default is Offset(0.0, 0.0).
  final Offset offset;

  /// The border color for the badge.
  /// If not provided, uses surface white color.
  final Color? borderColor;

  /// Creates a [UiIndicator] widget.
  const UiIndicator({
    super.key,
    required this.isVisible,
    required this.child,
    this.offset = Offset.zero,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: offset.dy,
          right: -offset.dx,
          child: Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: context.uiColors.warning,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? context.uiColors.surfaceWhite,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
