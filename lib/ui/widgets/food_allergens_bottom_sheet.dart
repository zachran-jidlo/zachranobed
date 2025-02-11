import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/model/food_allergen.dart';

/// A utility class for displaying a bottom sheet with a list of food allergens.
class FoodAllergensBottomSheet {
  /// Private constructor to prevent instantiation.
  FoodAllergensBottomSheet._();

  /// Shows a bottom sheet containing a list of food allergens.
  ///
  /// The bottom sheet is scrollable and displays the allergens with their
  /// corresponding numbers.
  static void show(
    BuildContext context,
    List<FoodAllergen> allergens,
  ) {
    final itemWidgets = allergens.map((allergen) {
      return Text(
        "${allergen.number}. ${allergen.text}",
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }).separated(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          width: double.infinity,
          color: ZOColors.secondary,
          height: 1.0,
        ),
      ),
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.5,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n!.allergensList,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 28),
                    ...itemWidgets,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
