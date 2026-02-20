import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// Displays a compact text summary of the selected allergen sub-items.
///
/// Returns an empty widget if [currentSelection] contains no sub-item entries.
class FoodAllergenSubItemsLabel extends StatelessWidget {
  /// The currently selected allergen keys (e.g. ["1", "1a", "1c", "2", "8b"]).
  final List<String> currentSelection;

  const FoodAllergenSubItemsLabel({
    super.key,
    required this.currentSelection,
  });

  @override
  Widget build(BuildContext context) {
    final parts = _buildParts(context);
    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        context.l10n.allergensSubItemsTemplate(parts.join(', ')),
        style: context.textStyles.bodyMedium,
      ),
    );
  }

  List<String> _buildParts(BuildContext context) {
    final parts = <String>[];
    for (final allergen in FoodAllergen.all(context)) {
      if (allergen.subItems.isEmpty) {
        continue;
      }

      final number = allergen.number;
      if (currentSelection.contains(number.toString())) {
        // All sub-items were selected as a group, do not need to specify sub-items
        continue;
      }

      for (final sub in allergen.subItems) {
        if (currentSelection.contains(sub.key(number))) {
          parts.add('${sub.key(number)}\u{00A0}${sub.text}');
        }
      }
    }
    return parts;
  }
}
