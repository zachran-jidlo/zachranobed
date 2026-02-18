import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';

/// A customizable list item tile with slot-based content areas.
///
/// Supports start slot (leading area), main content area (title with optional overline/supporting text), and end
/// slot (trailing area).
class UiListTile extends StatelessWidget {
  /// The main title text (required).
  final String title;

  /// Optional overline text displayed above the title.
  final String? overline;

  /// Optional supporting text displayed below the title.
  final String? supportingText;

  /// Optional widget displayed in the start area (leading).
  /// Typically used for icons, avatars, or other leading content.
  final Widget? start;

  /// Optional widget displayed in the end area (trailing).
  /// This can be any widget: text, icon, button, or combination.
  final Widget? end;

  /// Optional press callback. When provided, the card becomes tappable with ripple effect.
  final VoidCallback? onPressed;

  /// Creates a [UiListTile] widget.
  const UiListTile({
    super.key,
    required this.title,
    this.overline,
    this.supportingText,
    this.start,
    this.end,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      borderRadius: 8.0,
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
        children: [
          if (start != null) ...[
            start!,
          ],
          Expanded(
            child: _buildMainContent(context),
          ),
          if (end != null) ...[
            end!,
          ],
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (overline != null)
          Text(
            overline!,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
        Text(
          title,
          style: context.textStyles.titleMedium.copyWith(
            color: context.uiColors.textPrimary,
          ),
        ),
        if (supportingText != null)
          Text(
            supportingText!,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
