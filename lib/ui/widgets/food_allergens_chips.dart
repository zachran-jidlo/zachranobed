import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/assist_chip.dart';

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
class FoodAllergensChips extends StatelessWidget {
  /// A constant representing the absence of allergens.
  static const _noAllergensNumber = "0";

  /// A list of allergen numbers.
  static final _allergensList = List.generate(14, (i) => "${i + 1}");

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
                    ..._allergensList.map(
                      (number) {
                        return AssistChip(
                          text: number,
                          selected: state.value!.contains(number),
                          onPressed: () {
                            _onRegularAllergenPressed(state, number);
                          },
                        );
                      },
                    ),
                    AssistChip(
                      text: context.l10n!.allergensNotPresent,
                      selected: state.value!.contains(_noAllergensNumber),
                      onPressed: () {
                        _onNoAllergenPressed(state);
                      },
                    ),
                  ],
                ),
              ),
              if (state.hasError) _buildError(context, state),
            ],
          ),
        );
      },
    );
  }

  /// Handles the press event for a regular allergen chip.
  void _onRegularAllergenPressed(
    FormFieldState<List<String>> state,
    String number,
  ) {
    final currentSelection = state.value ?? [];
    final newSelection = List<String>.from(currentSelection);
    newSelection.remove(FoodAllergensChips._noAllergensNumber);
    if (currentSelection.contains(number)) {
      newSelection.remove(number);
    } else {
      newSelection.add(number);
    }
    state.didChange(newSelection);
    onSelectionChanged(newSelection);
  }

  /// Handles the press event for the "no allergens" chip.
  void _onNoAllergenPressed(FormFieldState<List<String>> state) {
    final currentSelection = state.value ?? [];
    final List<String> newSelection;
    if (currentSelection.contains(FoodAllergensChips._noAllergensNumber)) {
      newSelection = [];
    } else {
      newSelection = [FoodAllergensChips._noAllergensNumber];
    }
    state.didChange(newSelection);
    onSelectionChanged(newSelection);
  }

  /// Builds the error message widget.
  ///
  /// TODO (Alex) Fix error text style to match Figma
  Widget _buildError(BuildContext context, FormFieldState<List<String>> state) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: 4.0,
        left: WidgetStyle.paddingSmall,
      ),
      child: Text(
        state.errorText!,
        style: textTheme.bodySmall?.copyWith(color: ZOColors.primary),
      ),
    );
  }
}
