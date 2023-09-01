import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum FoodCategory {
  warm,
  cooled,
}

abstract class FoodCategoryHelper {
  static String toValue(FoodCategory packaging, BuildContext context) {
    switch (packaging) {
      case FoodCategory.warm:
        return context.l10n!.foodCategoryWarm;
      case FoodCategory.cooled:
        return context.l10n!.foodCategoryCooled;
      default:
        return '';
    }
  }
}
