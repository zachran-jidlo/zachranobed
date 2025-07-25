import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/widgets/trailing_icon_row.dart';

/// A widget that displays a single [FoodInfo] object as a row.
///
/// The row typically includes information like the dish name, description,
/// count, and an edit icon. When the row is tapped, the [onPressed] callback
/// is invoked.
class FoodInfoRow extends StatelessWidget {
  /// The [FoodInfo] object to display in the row.
  final FoodInfo foodInfo;

  /// The callback that is called when the row is pressed.
  final Function() onPressed;

  /// The background color of the row.
  final Color? background;

  /// Creates a [FoodInfoRow] widget.
  const FoodInfoRow({
    super.key,
    required this.foodInfo,
    required this.onPressed,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    // Set count based on the number of servings or packages (for
    // packaged food category)
    final count = foodInfo.numberOfServings ?? foodInfo.numberOfPackages;

    return TrailingIconRow(
      title: foodInfo.dishName.toString(),
      description: null,
      trailInfo: context.l10n!.foodInfoCountTemplate(count ?? 0),
      trailingIcon: Icons.edit,
      background: background,
      onTap: onPressed,
    );
  }
}
