import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/domain/model/food_category.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_meal_tile.dart';
import 'package:zachranobed/common/presentation/widget/chip/ui_meal_badge.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/features/food/domain/model/food_date_time.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// Factory class for building meal tile components from [OfferedFood] items.
///
/// This class provides static methods to build consistent meal tile widgets
/// and badges across different screens.
class MealTileFactory {
  MealTileFactory._();

  /// Builds a complete [UiMealTile] widget for the given [item].
  static Widget buildMealTile(BuildContext context, OfferedFood item) {
    return UiMealTile(
      title: item.dishName,
      quantityLabel: _formatQuantity(context, item),
      badges: [
        _buildCategoryBadge(context, item),
        _buildAllergensBadge(context, item),
        _buildDateBadge(context, item),
      ],
    );
  }

  /// Formats the quantity label for the given [item].
  ///
  /// Returns the number of servings if available, otherwise the number of packages.
  static String _formatQuantity(BuildContext context, OfferedFood item) {
    if (item.numberOfServings != null) {
      return context.l10n.commonServingsCount(item.numberOfServings!);
    }
    if (item.numberOfPackages != null) {
      return context.l10n.commonCountTemplate(item.numberOfPackages!);
    }
    return '';
  }

  /// Builds a category badge for the given [item].
  static UiMealBadge _buildCategoryBadge(BuildContext context, OfferedFood item) {
    return switch (item.foodCategoryType) {
      FoodCategoryType.warm => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconHot),
          label: context.l10n.foodCategoryBadgeWarmTemplate(
            item.foodTemperature ?? Constants.foodTemperatureInitial,
          ),
        ),
      FoodCategoryType.cooled => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconCold),
          label: context.l10n.foodCategoryBadgeCooled,
        ),
      FoodCategoryType.packaged => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconPack),
          label: context.l10n.foodCategoryBadgePackaged,
        ),
      null => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconMeal),
          label: item.foodCategory,
        ),
    };
  }

  /// Builds an allergens badge for the given [item].
  static UiMealBadge _buildAllergensBadge(BuildContext context, OfferedFood item) {
    String allergensLabel;
    if (listEquals(item.allergens, [FoodAllergen.noAllergensNumber])) {
      allergensLabel = context.l10n.allergensNotPresent;
    } else if (listEquals(item.allergens, [FoodAllergen.onPackageNumber])) {
      allergensLabel = context.l10n.allergensOnPackage;
    } else {
      allergensLabel = item.allergens.join(', ');
    }
    return UiMealBadge(
      icon: UiIconSpec.svg(ImageAssets.iconAllergens),
      label: allergensLabel,
    );
  }

  /// Builds a date badge for the given [item].
  static UiMealBadge _buildDateBadge(BuildContext context, OfferedFood item) {
    final dateLabel = switch (item.consumeBy) {
      FoodDateTimeSpecified(date: final date) =>
        DateTimeUtils.formatDateTime(date, "d.M.y HH:mm"),
      FoodDateTimeOnPackaging() => context.l10n.foodDateTimeLabelOnPackaging,
    };

    return UiMealBadge(
      icon: UiIconSpec.svg(ImageAssets.iconCalendar),
      label: dateLabel,
    );
  }
}
