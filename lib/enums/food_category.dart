import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum FoodCategory {
  warm,
  cooled,
}

abstract class FoodCategoryHelper {
  /// Converts a [foodCategory] enum value to its corresponding localized
  /// string representation.
  static String toValue(FoodCategory foodCategory, BuildContext context) {
    switch (foodCategory) {
      case FoodCategory.warm:
        return context.l10n!.foodCategoryWarm;
      case FoodCategory.cooled:
        return context.l10n!.foodCategoryCooled;
      default:
        return '';
    }
  }
}
