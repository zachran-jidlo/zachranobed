import 'package:flutter/widgets.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// Represents a sub-item of a food allergen (e.g., "1a Pšenice" under allergen 1).
class FoodAllergenSubItem {
  /// The letter label of the sub-item (e.g., "a", "b").
  final String label;

  /// The localized text describing the sub-allergen.
  final String text;

  /// Creates a [FoodAllergenSubItem] instance.
  FoodAllergenSubItem({
    required this.label,
    required this.text,
  });

  /// Generates a key for the sub-item.
  String key(int number) {
    return '$number$label';
  }
}

/// Represents a food allergen with its number and localized text.
class FoodAllergen {
  /// A constant representing the absence of allergens.
  static const noAllergensNumber = "0";

  /// A constant representing that meal allergens are listed on the packaging.
  static const onPackageNumber = "-1";

  /// The number associated with the allergen.
  final int number;

  /// The localized text describing the allergen.
  final String text;

  /// Optional sub-items for allergens with sub-categories.
  final List<FoodAllergenSubItem> subItems;

  /// Creates a [FoodAllergen] instance.
  FoodAllergen({
    required this.number,
    required this.text,
    this.subItems = const [],
  });

  /// Creates a list of [FoodAllergen] instances with localized texts.
  static List<FoodAllergen> all(BuildContext context) {
    return [
      FoodAllergen(
        number: 1,
        text: context.l10n.allergen01,
        subItems: [
          FoodAllergenSubItem(label: 'a', text: context.l10n.allergen01a),
          FoodAllergenSubItem(label: 'b', text: context.l10n.allergen01b),
          FoodAllergenSubItem(label: 'c', text: context.l10n.allergen01c),
          FoodAllergenSubItem(label: 'd', text: context.l10n.allergen01d),
          FoodAllergenSubItem(label: 'e', text: context.l10n.allergen01e),
          FoodAllergenSubItem(label: 'f', text: context.l10n.allergen01f),
        ],
      ),
      FoodAllergen(number: 2, text: context.l10n.allergen02),
      FoodAllergen(number: 3, text: context.l10n.allergen03),
      FoodAllergen(number: 4, text: context.l10n.allergen04),
      FoodAllergen(number: 5, text: context.l10n.allergen05),
      FoodAllergen(number: 6, text: context.l10n.allergen06),
      FoodAllergen(number: 7, text: context.l10n.allergen07),
      FoodAllergen(
        number: 8,
        text: context.l10n.allergen08,
        subItems: [
          FoodAllergenSubItem(label: 'a', text: context.l10n.allergen08a),
          FoodAllergenSubItem(label: 'b', text: context.l10n.allergen08b),
          FoodAllergenSubItem(label: 'c', text: context.l10n.allergen08c),
          FoodAllergenSubItem(label: 'd', text: context.l10n.allergen08d),
          FoodAllergenSubItem(label: 'e', text: context.l10n.allergen08e),
          FoodAllergenSubItem(label: 'f', text: context.l10n.allergen08f),
          FoodAllergenSubItem(label: 'g', text: context.l10n.allergen08g),
          FoodAllergenSubItem(label: 'h', text: context.l10n.allergen08h),
        ],
      ),
      FoodAllergen(number: 9, text: context.l10n.allergen09),
      FoodAllergen(number: 10, text: context.l10n.allergen10),
      FoodAllergen(number: 11, text: context.l10n.allergen11),
      FoodAllergen(number: 12, text: context.l10n.allergen12),
      FoodAllergen(number: 13, text: context.l10n.allergen13),
      FoodAllergen(number: 14, text: context.l10n.allergen14),
    ];
  }
}
