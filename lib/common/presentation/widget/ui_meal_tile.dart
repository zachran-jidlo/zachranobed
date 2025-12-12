import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/iterable_widget_utils.dart';
import 'package:zachranobed/common/presentation/widget/ui_card.dart';

/// A tile widget that displays meal information with customizable badges.
///
/// This widget shows a card with a title, optional overline/supporting text,
/// quantity label, and a list of badge widgets displayed in a wrap layout.
class UiMealTile extends StatelessWidget {
  /// The name of the meal/dish.
  final String title;

  /// Optional overline text (shown above title in smaller text).
  final String? overline;

  /// Optional supporting text (shown below title).
  final String? supportingText;

  /// The quantity label shown on the right (e.g., "15 porcí", "10 ks").
  final String quantityLabel;

  /// List of badge widgets displayed below the title.
  /// Typically contains [UiMealBadge] widgets for meal type, allergens, expiry, etc.
  final List<Widget> badges;

  /// Creates a [UiMealTile].
  const UiMealTile({
    super.key,
    required this.title,
    this.overline,
    this.supportingText,
    required this.quantityLabel,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      padding: EdgeInsets.zero,
      borderRadius: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          if (badges.isNotEmpty) _buildBadges(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0,
              children: [
                if (overline != null) ...[
                  Text(
                    overline!,
                    style: context.textStyles.labelSmall.copyWith(
                      color: context.uiColors.textSecondary,
                    ),
                  ),
                ],
                Text(
                  title,
                  style: context.textStyles.titleMedium.copyWith(
                    color: context.uiColors.textPrimary,
                  ),
                ),
                if (supportingText != null) ...[
                  Text(
                    supportingText!,
                    style: context.textStyles.labelSmall.copyWith(
                      color: context.uiColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            quantityLabel,
            textAlign: TextAlign.right,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(BuildContext context) {
    return Container(
      color: context.uiColors.surfaceGray,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
        top: 8,
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: badges.separated(_buildDivider(context)).toList(),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: context.uiColors.surfaceGrayDark,
    );
  }
}
