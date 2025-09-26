import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a badge indicator.
class Indicator extends StatelessWidget {
  /// Determines whether the badge indicator should be visible.
  final bool isVisible;

  /// The child widget that the badge is attached to.
  final Widget child;

  /// Creates a [Indicator] widget.
  const Indicator({
    super.key,
    required this.isVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      smallSize: isVisible ? 12.0 : 0.0,
      backgroundColor: ZOColors.primary,
      child: child,
    );
  }
}
