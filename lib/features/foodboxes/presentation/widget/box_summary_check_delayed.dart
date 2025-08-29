import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/image_assets.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_card.dart';
import 'package:zachranobed/models/food_boxes_checkup_state.dart';

/// A card that displays the information that food boxes checkup was delayed.
class BoxSummaryCheckDelayed extends StatelessWidget {
  /// Whether the widget is in a loading state.
  final bool isLoading;

  /// The widget with food boxes data in the table.
  final Widget boxTable;

  /// The state of the delayed checkup.
  final FoodBoxesCheckupDelayed state;

  /// The callback function that is called when the user taps on the card.
  final VoidCallback onPressed;

  /// Creates a [BoxSummaryCheckDelayed] widget.
  const BoxSummaryCheckDelayed({
    super.key,
    required this.isLoading,
    required this.boxTable,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final days = state.duration.inDays;
    final hours = state.duration.inHours;
    final String time;
    if (days > 0) {
      time = context.l10n!.commonDaysCount(days);
    } else if (hours > 0) {
      time = context.l10n!.commonHoursCount(hours);
    } else {
      time = "< ${context.l10n!.commonHoursCount(1)}";
    }
    return Column(
      children: [
        BoxSummaryCard(
          onPressed: onPressed,
          child: Row(
            children: [
              SvgPicture.asset(
                ImageAssets.iconFoodBoxAlert,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  context.l10n!.foodBoxesCheckupDelayedCardDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ZOColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        boxTable,
      ],
    );
  }
}
