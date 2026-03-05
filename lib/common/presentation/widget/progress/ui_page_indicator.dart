import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a page indicator with animated dots for PageView.
///
/// The indicator shows dots that smoothly animate in size based on the current
/// page position. The active dot is largest, adjacent dots are medium-sized,
/// and other dots are smallest.
class UiPageIndicator extends StatefulWidget {
  /// The PageController to listen to for page changes.
  final PageController controller;

  /// The total number of pages/dots to display.
  final int pageCount;

  /// Creates a [UiPageIndicator] widget.
  const UiPageIndicator({
    super.key,
    required this.controller,
    required this.pageCount,
  });

  @override
  State<UiPageIndicator> createState() => _UiPageIndicatorState();
}

class _UiPageIndicatorState extends State<UiPageIndicator> {
  /// Size of the active (current) dot.
  static const double _activeDotSize = 12.0;

  /// Size of dots adjacent to the active dot.
  static const double _adjacentDotSize = 10.0;

  /// Size of other (inactive) dots.
  static const double _inactiveDotSize = 8.0;

  /// Spacing between dots.
  static const double _dotSpacing = 8.0;

  /// Duration of the animation.
  static const Duration _animationDuration = Duration(milliseconds: 200);

  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.controller.initialPage.toDouble();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void didUpdateWidget(UiPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onPageChanged);
      widget.controller.addListener(_onPageChanged);
      _currentPage = widget.controller.page ?? 0.0;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    final page = widget.controller.page;
    if (page != null) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _dotSpacing,
      children: List.generate(
        widget.pageCount,
        (index) => _buildDot(context, index),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final size = _calculateDotSize(index);
    final color = _calculateDotColor(context, index);

    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  double _calculateDotSize(int index) {
    final distance = (_currentPage - index).abs();

    if (distance < 1) {
      return _lerp(_activeDotSize, _adjacentDotSize, distance);
    } else if (distance < 2) {
      return _lerp(_adjacentDotSize, _inactiveDotSize, distance - 1);
    } else {
      return _inactiveDotSize;
    }
  }

  Color _calculateDotColor(BuildContext context, int index) {
    final colors = context.uiColors;
    final distance = (_currentPage - index).abs();

    if (distance < 1) {
      return Color.lerp(colors.primary, colors.inactive, distance)!;
    } else {
      return colors.inactive;
    }
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
