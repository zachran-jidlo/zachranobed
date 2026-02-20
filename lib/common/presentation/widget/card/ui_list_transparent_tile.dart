import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A customizable list item tile with slot-based content areas.
class UiListTransparentTile extends StatelessWidget {
  /// The main title text (required).
  final String title;

  /// Optional widget displayed in the start area (leading).
  /// Typically used for icons, avatars, or other leading content.
  final Widget? start;

  /// Optional widget displayed in the end area (trailing).
  /// This can be any widget: text, icon, button, or combination.
  final Widget? end;

  /// Optional press callback. When provided, the card becomes tappable with ripple effect.
  final VoidCallback? onPressed;

  /// Creates a [UiListTransparentTile] widget.
  const UiListTransparentTile({
    super.key,
    required this.title,
    this.start,
    this.end,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
      highlightColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8.0,
        children: [
          if (start != null) ...[
            start!,
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                title,
                style: context.textStyles.bodyLarge,
              ),
            ),
          ),
          if (end != null) ...[
            end!,
          ],
        ],
      ),
    );
  }
}
