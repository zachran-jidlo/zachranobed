import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// Factory class for building the allergen subtitle shown for a meal.
class FoodAllergensLabelFactory {
  const FoodAllergensLabelFactory._();

  /// Builds the allergen label for the given [allergens].
  static String build(BuildContext context, List<String> allergens) {
    return switch (FoodAllergensDisplay.of(allergens)) {
      FoodAllergensDisplay.none => context.l10n.allergensNotPresent,
      FoodAllergensDisplay.onPackage => context.l10n.allergensOnPackageLong,
      FoodAllergensDisplay.list => '${context.l10n.allergens}: ${allergens.join(', ')}',
    };
  }
}
