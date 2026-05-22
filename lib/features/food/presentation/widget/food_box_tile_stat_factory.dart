import 'package:flutter/material.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_tile.dart';
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
  /// Returns stats with appropriate labels based on the [user] type:
  /// - For [Canteen]: available quantity at canteen, then quantity at charity
  /// - For [Charity]: available quantity at charity, then quantity at canteen
  ///
  /// When [showOnTheWay] is `true`, an aggregated in-transit cell is inserted
  /// between the two main stats.
  static List<UiFoodBoxTileStat> buildFullTileStats(
    BuildContext context,
    UserData user,
    FoodBoxStatistics stat, {
    bool showOnTheWay = false,
  }) {
    final onTheWayStat = showOnTheWay
        ? UiFoodBoxTileStat(
            value: stat.quantityOnTheWay,
            label: context.l10n.overviewFoodBoxesOnTheWayLabel,
          )
        : null;

    switch (user) {
      case Canteen():
        return [
          UiFoodBoxTileStat(
            value: stat.availableQuantityAtCanteen,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          if (onTheWayStat != null) onTheWayStat,
          UiFoodBoxTileStat(
            value: stat.availableQuantityAtCharity,
            label: context.l10n.charity,
          ),
        ];
      case Charity():
        return [
          UiFoodBoxTileStat(
            value: stat.availableQuantityAtCharity,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          if (onTheWayStat != null) onTheWayStat,
          UiFoodBoxTileStat(
            value: stat.availableQuantityAtCanteen,
            label: context.l10n.canteen,
          ),
        ];
    }
  }

  /// Builds the in-transit breakdown relative to the [user]'s role.
  ///
  /// `incoming` is the count heading towards the user. `outgoing` is the count
  /// leaving the user.
  static UiFoodBoxTileOnTheWay buildOnTheWay(
    UserData user,
    FoodBoxStatistics stat,
  ) {
    switch (user) {
      case Canteen():
        return UiFoodBoxTileOnTheWay(
          incoming: stat.quantityOnTheWayToCanteen,
          outgoing: stat.quantityOnTheWayToCharity,
        );
      case Charity():
        return UiFoodBoxTileOnTheWay(
          incoming: stat.quantityOnTheWayToCharity,
          outgoing: stat.quantityOnTheWayToCanteen,
        );
    }
  }
}
