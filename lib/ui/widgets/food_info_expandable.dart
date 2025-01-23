import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/widgets/expandable_container.dart';
import 'package:zachranobed/ui/widgets/food_info_row.dart';

/// A widget that displays a list of [FoodInfo] objects in an expandable card.
/// Card is visible when [foodInfos] list is not empty, card is expandable if
/// [foodInfos] list contains more than 1 item.
class FoodInfoExpandable extends StatelessWidget {
  /// The list of [FoodInfo] objects to display.
  final List<FoodInfo> foodInfos;

  /// The callback that is called when a [FoodInfo] item is pressed.
  final Function(FoodInfo) onFoodInfoPressed;

  /// Whether the widget is currently expanded.
  final bool isExpanded;

  /// The callback that is called when the widget is expanded or collapsed.
  final Function(bool) onExpandedChanged;

  /// Creates a [FoodInfoExpandable] widget.
  const FoodInfoExpandable({
    super.key,
    required this.foodInfos,
    required this.onFoodInfoPressed,
    required this.isExpanded,
    required this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (foodInfos.isEmpty) {
      return const SizedBox();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ZOColors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: foodInfos.length > 1 ? 0.0 : 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n!.offerFoodFormFoodInfoHeader,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            ExpandableContainer(
              labelExpand: context.l10n!.offerFoodFormFoodInfoExpandAction,
              labelCollapse: context.l10n!.offerFoodFormFoodInfoCollapseAction,
              isExpandable: foodInfos.length > 1,
              isExpanded: isExpanded,
              onExpandedChanged: onExpandedChanged,
              child: Column(
                children: _foodInfoWidgets(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _foodInfoWidgets() {
    return foodInfos
        .map(
          (food) => FoodInfoRow(
            foodInfo: food,
            background: ZOColors.lightBorderColor,
            onPressed: () => onFoodInfoPressed(food),
          ),
        )
        .separated(const SizedBox(height: 8.0))
        .toList();
  }
}
