import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';

/// A tile widget that displays a notification with optional actions.
///
/// This widget shows a card with an optional icon, title, optional description, optional trailing widget, and
/// optional action buttons. The layout adapts based on which properties are provided.
class UiNotificationTile extends StatelessWidget {
  /// The title displayed in the notification.
  final String title;

  /// The description text displayed below the title.
  final String? description;

  /// Custom widget displayed in place of [description]. Takes precedence over
  /// [description] when provided (e.g. to render rich/markdown content).
  final Widget? descriptionWidget;

  /// The icon to display.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The trailing widget to display (e.g., close button, info icon).
  final Widget? trailing;

  /// Action buttons displayed at the bottom of the tile.
  final List<Widget>? actions;

  /// Creates a [UiNotificationTile] widget.
  const UiNotificationTile({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.icon,
    this.iconColor,
    this.trailing,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, trailing),
          _buildDescription(context, description, descriptionWidget),
          _buildActions(actions),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Widget? trailing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        if (icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 16.0,
              right: 8.0,
            ),
            child: Icon(
              icon,
              size: 24,
              color: iconColor ?? context.uiColors.primary,
            ),
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.titleMedium.copyWith(
                color: context.uiColors.textPrimary,
              ),
            ),
          ),
        ),
        if (trailing != null) ...[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: trailing,
          ),
        ],
      ],
    );
  }

  Widget _buildDescription(BuildContext context, String? description, Widget? descriptionWidget) {
    final content = descriptionWidget ?? _buildDescriptionText(context, description);
    if (content == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: content,
    );
  }

  Widget? _buildDescriptionText(BuildContext context, String? description) {
    if (description == null) {
      return null;
    }

    return Text(
      description,
      style: context.textStyles.bodyMedium.copyWith(
        color: context.uiColors.textPrimary,
      ),
    );
  }

  Widget _buildActions(List<Widget>? actions) {
    if (actions == null || actions.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        spacing: 8.0,
        children: actions.map((action) => Expanded(child: action)).toList(),
      ),
    );
  }
}
