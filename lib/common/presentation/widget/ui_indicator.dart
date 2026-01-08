import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a badge indicator over a child widget.
///
/// The indicator punches a hole through the child widget to create
/// a clean cutout effect for the badge.
class UiIndicator extends StatelessWidget {
  /// The size of the badge indicator in logical pixels.
  static const double _badgeSize = 12.0;

  /// The radius of the badge (half of the size).
  static const double _badgeRadius = _badgeSize / 2;

  /// Additional spacing around the badge for the hole cutout.
  static const double _holeSpacing = 1.0;

  /// Determines whether the badge indicator should be visible.
  final bool isVisible;

  /// The child widget that the badge is attached to.
  final Widget child;

  /// Offset for the badge position.
  /// The offset is applied from the top-right corner of the child.
  /// Default is Offset(0.0, 0.0).
  final Offset offset;

  /// Creates a [UiIndicator] widget.
  const UiIndicator({
    super.key,
    required this.isVisible,
    required this.child,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: _BadgeHoleClipper(
            offset: offset,
            badgeRadius: _badgeRadius,
            holeSpacing: _holeSpacing,
          ),
          child: child,
        ),
        Positioned(
          top: offset.dy,
          right: -offset.dx,
          child: Container(
            width: _badgeSize,
            height: _badgeSize,
            decoration: BoxDecoration(
              color: context.uiColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper that punches a circular hole for the badge indicator.
class _BadgeHoleClipper extends CustomClipper<Path> {
  final Offset offset;
  final double badgeRadius;
  final double holeSpacing;

  _BadgeHoleClipper({
    required this.offset,
    required this.badgeRadius,
    required this.holeSpacing,
  });

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate badge center position
    // Badge is positioned at top-right with offset applied
    final badgeCenter = Offset(
      size.width + offset.dx - badgeRadius,
      offset.dy + badgeRadius,
    );

    // Punch a hole with additional spacing around the badge
    final holeRadius = badgeRadius + holeSpacing;
    final holePath = Path()..addOval(Rect.fromCircle(center: badgeCenter, radius: holeRadius));

    // Subtract the hole from the main path
    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(_BadgeHoleClipper oldClipper) {
    return oldClipper.offset != offset ||
        oldClipper.badgeRadius != badgeRadius ||
        oldClipper.holeSpacing != holeSpacing;
  }
}
