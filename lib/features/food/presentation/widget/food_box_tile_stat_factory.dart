import 'package:flutter/material.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/ui_food_box_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';

/// A utility class for building [UiFoodBoxTileStat] lists based on user type.
///
/// This class provides factory methods to create statistics displays that are
/// tailored to the user's role (canteen or charity), showing relevant labels
/// and quantities for each.
class FoodBoxTileStatFactory {
  /// Private constructor to prevent instantiation.
  FoodBoxTileStatFactory._();

  /// Builds a list of [UiFoodBoxTileStat] for a full-size tile display.
  ///
  /// Returns statistics with appropriate labels based on the [user] type:
  /// - For [Canteen]: shows available quantity at canteen and quantity at charity
  /// - For [Charity]: shows available quantity at charity and quantity at canteen
  static List<UiFoodBoxTileStat> buildFullTileStats(
    BuildContext context,
    UserData user,
    FoodBoxStatistics stat,
  ) {
    switch (user) {
      case Canteen():
        return [
          UiFoodBoxTileStat(
            value: stat.quantityAtCanteen,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          UiFoodBoxTileStat(
            value: stat.quantityAtCharity,
            label: context.l10n.charity,
          ),
        ];
      case Charity():
        return [
          UiFoodBoxTileStat(
            value: stat.quantityAtCharity,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          UiFoodBoxTileStat(
            value: stat.quantityAtCanteen,
            label: context.l10n.canteen,
          ),
        ];
    }
  }
}
