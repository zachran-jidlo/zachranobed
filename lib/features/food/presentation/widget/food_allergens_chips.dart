import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/chip/ui_chip.dart';
import 'package:zachranobed/common/presentation/widget/form/form_field_error.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_tooltip.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergen_sub_selection_bottom_sheet.dart';

/// A widget that displays a set of chips representing food allergens.
///
/// This widget allows users to select multiple allergens or indicate that
/// no allergens are present. It uses [AssistChip] widgets to represent
/// each allergen and provides callbacks for handling selection changes
/// and validation. Internally uses [FormField] for validation in [Form].
///
/// When user selects "no allergens" option, widget clears any other allergen
/// selected. Similarly when user selects any allergen, then the "no allergens"
/// option is deselected.
///
/// For allergens with sub-categories (e.g. allergen 1 and 8), tapping the chip
/// opens a bottom sheet to select specific sub-items. The selection is stored
/// as all-sub-items-selected → parent number (e.g. "1"), or partial selection
/// as individual keys (e.g. "1a", "1b").
class FoodAllergensChips extends StatelessWidget {
  /// The currently selected allergens.
  final List<String> selection;

  /// Callback function triggered when the selection changes.
  final Function(List<String>) onSelectionChanged;

  /// Focus node for the widget.
  final FocusNode? focusNode;

  /// Signature for validating a form field.
  final FormFieldValidator<List<String>>? onValidation;

  /// Creates a [FoodAllergensChips] widget.
  const FoodAllergensChips({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
    this.focusNode,
    this.onValidation,
  });

  @override
  Widget build(BuildContext context) {
    final allergens = FoodAllergen.all(context);
    return FormField<List<String>>(
      initialValue: selection,
      validator: onValidation,
      builder: (state) {
        return Focus(
          focusNode: focusNode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    ...allergens.map(
                      (allergen) {
                        final number = allergen.number.toString();
                        return UiTooltip(
                          message: allergen.text,
                          child: UiChip(
                            text: number,
                            selected: _isAllergenSelected(allergen, state.value!),
                            onPressed: () => _onAllergenPressed(context, state, allergen),
                          ),
                        );
                      },
                    ),
                    UiChip(
                      text: context.l10n.allergensNotPresent,
                      selected: state.value!.contains(FoodAllergen.noAllergensNumber),
                      onPressed: () => _onSingleSelectPressed(state, FoodAllergen.noAllergensNumber),
                    ),
                    UiChip(
                      text: context.l10n.allergensOnPackage,
                      selected: state.value!.contains(FoodAllergen.onPackageNumber),
                      onPressed: () => _onSingleSelectPressed(state, FoodAllergen.onPackageNumber),
                    ),
                  ],
                ),
              ),
              if (state.hasError) FormFieldError(message: state.errorText ?? ""),
            ],
          ),
        );
      },
    );
  }

  bool _isAllergenSelected(FoodAllergen allergen, List<String> selection) {
    if (selection.contains(allergen.number.toString())) {
      return true;
    }
    return allergen.subItems.any((sub) => selection.contains(sub.key(allergen.number)));
  }

  void _onAllergenPressed(
    BuildContext context,
    FormFieldState<List<String>> state,
    FoodAllergen allergen,
  ) async {
    if (allergen.subItems.isNotEmpty) {
      final result = await FoodAllergenSubSelectionBottomSheet.show(
        context,
        allergen: allergen,
        currentSelection: state.value!,
      );

      if (result != null && context.mounted && state.mounted) {
        _onSubAllergenSaved(state, allergen, result);
      }
    } else {
      _onRegularAllergenPressed(state, allergen.number.toString());
    }
  }

  void _onSubAllergenSaved(
    FormFieldState<List<String>> state,
    FoodAllergen allergen,
    List<String> savedValues,
  ) {
    final newSelection = List<String>.from(state.value ?? []);
    // Remove the main number and any sub-item keys for this allergen
    newSelection.remove(allergen.number.toString());
    for (final sub in allergen.subItems) {
      newSelection.remove(sub.key(allergen.number));
    }
    if (savedValues.isNotEmpty) {
      // Clear single-select options when a real allergen is added
      newSelection.remove(FoodAllergen.noAllergensNumber);
      newSelection.remove(FoodAllergen.onPackageNumber);
      newSelection.addAll(savedValues);
    }
    newSelection.sort(compareNatural);
    state.didChange(newSelection);
    onSelectionChanged(newSelection);
  }

  /// Handles the press event for a regular allergen chip.
  void _onRegularAllergenPressed(
    FormFieldState<List<String>> state,
    String number,
  ) {
    final currentSelection = state.value ?? [];
    final newSelection = List<String>.from(currentSelection);
    newSelection.remove(FoodAllergen.noAllergensNumber);
    newSelection.remove(FoodAllergen.onPackageNumber);
    if (currentSelection.contains(number)) {
      newSelection.remove(number);
    } else {
      newSelection.add(number);
    }
    newSelection.sort(compareNatural);
    state.didChange(newSelection);
    onSelectionChanged(newSelection);
  }

  /// Handles the press event for the "no allergens" or "allergens on package" chips.
  void _onSingleSelectPressed(FormFieldState<List<String>> state, String number) {
    final currentSelection = state.value ?? [];
    final List<String> newSelection;
    if (currentSelection.contains(number)) {
      newSelection = [];
    } else {
      newSelection = [number];
    }
    state.didChange(newSelection);
    onSelectionChanged(newSelection);
  }
}
