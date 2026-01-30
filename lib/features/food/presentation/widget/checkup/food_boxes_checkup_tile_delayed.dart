import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/ui_list_tile.dart';

/// A banner widget displayed when food boxes checkup has been delayed.
class FoodBoxesCheckupTileCheckDelayed extends StatelessWidget {
  /// The remaining duration until checkup is required.
  final Duration remainingDuration;

  /// The callback that is called when the tile is tapped.
  final VoidCallback onPressed;

  /// Creates a [FoodBoxesCheckupTileCheckDelayed] widget.
  const FoodBoxesCheckupTileCheckDelayed({
    super.key,
    required this.remainingDuration,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final days = remainingDuration.inDays;
    final hours = remainingDuration.inHours;
    final String time;
    if (days > 0) {
      time = context.l10n.commonDaysAccusativeCount(days);
    } else if (hours > 0) {
      time = context.l10n.commonHoursAccusativeCount(hours);
    } else {
      time = "< ${context.l10n.commonHoursAccusativeCount(1)}";
    }
    return UiListTile(
      title: context.l10n.foodBoxesCheckupDelayedCardDescription,
      supportingText: context.l10n.foodBoxesCheckupDelayedCountdownTemplate(time),
      onPressed: onPressed,
      start: UiIcon(
        spec: UiIconSpec.svg(ImageAssets.iconFoodBoxAlert, applyTint: false),
      ),
      end: UiGradientIcon(
        spec: UiIconSpec.data(Icons.chevron_right),
        gradient: context.uiColors.primaryGradient,
        size: 24,
      ),
    );
  }
}
