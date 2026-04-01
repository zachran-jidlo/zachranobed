import 'package:flutter/material.dart';

/// A widget that displays content with an optional loading indicator. The [child] is always displayed to keep the
/// necessary widget size.
class ContentWithLoading extends StatelessWidget {
  /// Whether the loading indicator should be displayed.
  final bool isLoading;

  /// The child widget that will be displayed when not loading.
  final Widget child;

  /// Creates a [ContentWithLoading] widget.
  const ContentWithLoading({
    super.key,
    this.isLoading = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        ),
        if (isLoading) const CircularProgressIndicator(),
      ],
    );
  }
}
