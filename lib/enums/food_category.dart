import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

/// Represents the type of a food category.
enum FoodCategoryType {
  /// Represents a warm food category.
  warm,

  /// Represents a cooled food category.
  cooled,
}

/// Represents a food category.
class FoodCategory {
  /// The name of this food category to show in UI.
  final String name;

  /// The type of this food category.
  final FoodCategoryType type;

  /// Creates a [FoodCategory] instance.
  const FoodCategory({required this.name, required this.type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodCategory &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;

  /// Creates a list of [FoodCategory] values based on the provided context.
  static List<FoodCategory> createValues(BuildContext context) {
    return [
      FoodCategory(
        name: context.l10n!.foodCategoryWarm,
        type: FoodCategoryType.warm,
      ),
      FoodCategory(
        name: context.l10n!.foodCategoryCooled,
        type: FoodCategoryType.cooled,
      ),
    ];
  }
}
