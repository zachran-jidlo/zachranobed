import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A card widget with custom shadow styling.
class UiCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// The padding inside the card.
  final EdgeInsetsGeometry padding;

  /// The border radius of the card.
  final double borderRadius;

  /// Optional press callback. When provided, the card becomes tappable with ripple effect.
  final VoidCallback? onPressed;

  /// Creates a [UiCard] widget.
  const UiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: child,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Material(
        color: context.uiColors.surfaceWhite,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: onPressed != null
            ? InkWell(
                onTap: onPressed,
                splashColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
                highlightColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
                child: content,
              )
            : content,
      ),
    );
  }
}
