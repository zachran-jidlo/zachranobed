import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// Factory class for building the allergen subtitle shown for a meal.
class MealAllergensLabelFactory {
  const MealAllergensLabelFactory._();

  /// Builds the allergen label for the given [allergens].
  ///
  /// A single [FoodAllergen.noAllergensNumber] or [FoodAllergen.onPackageNumber]
  /// is rendered as its own label.
  static String build(BuildContext context, List<String> allergens) {
    if (allergens.isEmpty || (allergens.length == 1 && allergens.first == FoodAllergen.noAllergensNumber)) {
      return context.l10n.allergensNotPresent;
    }
    if (allergens.length == 1 && allergens.first == FoodAllergen.onPackageNumber) {
      return context.l10n.allergensOnPackageLong;
    }
    return '${context.l10n.allergens}: ${allergens.join(', ')}';
  }
}
