import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/ui_indicator.dart';

/// A tile widget for displaying and selecting entity pairs (canteens/charities).
class UiChangePairTile extends StatelessWidget {
  /// The name of the entity (canteen or charity).
  final String name;

  /// The label text to display above the name for active entities.
  final String? activeLabel;

  /// Callback when the select button is pressed.
  final VoidCallback? onSelectPressed;

  /// Whether to show the indicator badge on the select button.
  final bool showIndicator;

  /// Creates a [UiChangePairTile] widget.
  const UiChangePairTile({
    super.key,
    required this.name,
    this.activeLabel,
    this.onSelectPressed,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      borderRadius: 8.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
        children: [
          Expanded(
            child: _buildContent(context),
          ),
          _buildSelectButton(context, onSelectPressed),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        if (activeLabel != null)
          Text(
            activeLabel!,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
        Text(
          name,
          style: context.textStyles.titleMedium.copyWith(
            color: context.uiColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(BuildContext context, VoidCallback? onSelectPressed) {
    if (onSelectPressed == null) {
      return SizedBox();
    }

    return UiIndicator(
      isVisible: showIndicator,
      offset: Offset(-12, -6),
      child: UiPrimaryButton(
        text: context.l10n.activePairCardSelectAction,
        onPressed: onSelectPressed,
      ),
    );
  }
}
