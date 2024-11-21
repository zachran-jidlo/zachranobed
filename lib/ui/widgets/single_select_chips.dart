import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/assist_chip.dart';
import 'package:zachranobed/ui/widgets/form_field_error.dart';

/// A widget that displays a set of chips for single selection.
///
/// This widget allows users to select a single option from a list of choices
/// represented by chips. It uses [AssistChip] widgets to display the options
/// and provides callbacks for handling selection changes and validation.
/// Internally uses [FormField] for validation in [Form].
class SingleSelectChips <T> extends StatelessWidget {
  /// The currently selected chip, or null.
  final T? selection;

  /// Callback function triggered when the selection changes.
  final Function(T?) onSelectionChanged;

  /// The list of available options.
  final List<T> options;

  /// Focus node for the widget.
  final FocusNode? focusNode;

  /// Signature for validating a form field.
  final FormFieldValidator<T?>? onValidation;

  /// Lambda function to format the option name.
  final String Function(T) optionLabel;

  /// Creates a [SingleSelectChips] widget.
  const SingleSelectChips({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
    required this.options,
    required this.optionLabel,
    this.focusNode,
    this.onValidation,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
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
                  spacing: GapSize.xs,
                  runSpacing: GapSize.xs,
                  children: options.map((option) {
                    return AssistChip(
                      text: optionLabel(option),
                      selected: option == state.value,
                      onPressed: () {
                        state.didChange(option);
                        onSelectionChanged(option);
                      },
                    );
                  }).toList(),
                ),
              ),
              if (state.hasError)
                FormFieldError(message: state.errorText ?? ""),
            ],
          ),
        );
      },
    );
  }
}
