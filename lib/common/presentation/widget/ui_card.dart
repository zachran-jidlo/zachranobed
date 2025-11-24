import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A card widget with custom shadow styling.
class UiCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// The padding inside the card.
  final EdgeInsetsGeometry padding;

  /// Creates a [UiCard] widget.
  const UiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.uiColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: child,
    );
  }
}
