import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

/// A utility class for displaying a bottom sheet with a list of food allergens.
class FoodAllergensBottomSheet {

  /// Private constructor to prevent instantiation.
  FoodAllergensBottomSheet._();

  /// Shows a bottom sheet containing a list of food allergens.
  ///
  /// The bottom sheet is scrollable and displays the allergens with their
  /// corresponding numbers.
  static void show(BuildContext context) {
    final items = [
      context.l10n!.allergen01,
      context.l10n!.allergen02,
      context.l10n!.allergen03,
      context.l10n!.allergen04,
      context.l10n!.allergen05,
      context.l10n!.allergen06,
      context.l10n!.allergen07,
      context.l10n!.allergen08,
      context.l10n!.allergen09,
      context.l10n!.allergen10,
      context.l10n!.allergen11,
      context.l10n!.allergen12,
      context.l10n!.allergen13,
      context.l10n!.allergen14,
    ];

    final itemWidgets = items.mapIndexed((index, allergenName) {
      return Text(
        "${index + 1}. $allergenName",
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
