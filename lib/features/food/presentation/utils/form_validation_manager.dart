import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Manages the validation states of form fields.
///
/// Heavily inspired by: https://stackoverflow.com/a/68492614
class FormValidationManager {
  /// Alignment for the scroll position when scrolling to an error.
  /// Uses 20% offset from screen top.
  static const double scrollAlignment = 0.2;

  /// Duration for the scroll animation when scrolling to an error.
  static const Duration scrollDuration = Duration(milliseconds: 250);

  // Map to hold the validation state of each form field.
  final _fieldStates = <String, _FormFieldValidationState>{};

  /// Retrieves the validation state for the given field key, creating
  /// a new one if absent.
  _FormFieldValidationState _getState(String key) =>
      _fieldStates.putIfAbsent(key, () => _FormFieldValidationState(key));

  /// Returns the [FocusNode] associated with the given field key.
  FocusNode getFocusNode(String key) {
    return _getState(key).focusNode;
  }

  /// Wraps the provided validator to update the validation state based on its
  /// result.
  FormFieldValidator<T> wrapValidator<T>(
    String key,
    FormFieldValidator<T> validator,
  ) {
    return (input) {
      final result = validator(input);
      _getState(key).hasError = result?.isNotEmpty ?? false;
      return result;
    };
  }

  /// Scrolls to the first field with a validation error.
  void scrollToFirstError() {
    // Find the context of the first field with an error.
    final fieldContext = _fieldStates.entries
        .where((s) => s.value.hasError)
        .map((s) => s.value)
        .firstOrNull
        ?.focusNode
        .context;

    if (fieldContext == null) {
      return;
    }

    // Ensure the first field with an error is visible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        fieldContext,
        alignment: scrollAlignment,
        duration: scrollDuration,
      );
    });
  }

  /// Disposes of all FocusNodes to free up resources.
  void dispose() {
    for (var s in _fieldStates.entries) {
      s.value.focusNode.dispose();
    }
    _fieldStates.clear();
  }
}

/// Represents the validation state of a form field.
class _FormFieldValidationState {
  final String key;

  bool hasError = false;
  FocusNode focusNode = FocusNode();

  /// Initializes a new validation state for the specified field key.
  _FormFieldValidationState(this.key);
}
