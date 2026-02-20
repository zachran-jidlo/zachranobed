import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_transparent_tile.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// A utility class for displaying a bottom sheet with a list of food allergens.
class FoodAllergensBottomSheet {
  /// Private constructor to prevent instantiation.
  FoodAllergensBottomSheet._();

  /// Shows a bottom sheet containing a list of food allergens.
  ///
  /// The bottom sheet is scrollable and displays the allergens with their
  /// corresponding numbers. Allergens with sub-categories show their
  /// sub-items with a dash icon.
  static void show(
    BuildContext context,
    List<FoodAllergen> allergens, {
    bool fullHeight = false,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints.tightFor(width: 640.0),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: fullHeight ? 1.0 : 0.5,
          minChildSize: 0.5,
          expand: false,
          snap: true,
          snapSizes: const [0.5, 1.0],
          builder: (_, controller) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: controller,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.allergensList,
                            style: context.textStyles.titleLarge,
                          ),
                          const SizedBox(height: 28),
                          ..._buildItems(context, allergens),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static List<Widget> _buildItems(
    BuildContext context,
    List<FoodAllergen> allergens,
  ) {
    final items = <Widget>[];
    final divider = Container(
      width: double.infinity,
      height: 1.0,
      color: context.uiColors.inactive,
    );

    for (var i = 0; i < allergens.length; i++) {
      final allergen = allergens[i];

      items.add(
        UiListTransparentTile(
          title: "${allergen.number}. ${allergen.text}",
        ),
      );

      for (final subItem in allergen.subItems) {
        items.add(
          UiListTransparentTile(
            title: "${allergen.number}${subItem.label} ${subItem.text}",
            start: Icon(
              Icons.remove,
              size: 24,
              color: context.uiColors.textPrimary,
            ),
          ),
        );
      }

      if (i < allergens.length - 1) {
        items.add(divider);
      }
    }

    return items;
  }
}
