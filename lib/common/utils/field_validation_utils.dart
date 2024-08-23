import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

/// Provides utility methods for field validation.
class FieldValidationUtils {
  FieldValidationUtils._();

  /// Regular expression for validating an email address.
  static RegExp emailRegExp = RegExp(
      "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+");

  /// Returns a validator for email field.
  /// The validator checks if the value is not empty and contains a valid email
  /// address.
  static String? Function(String?) getEmailValidator(BuildContext context) {
    return (value) {
      if (value == null || value.isEmpty) {
        return context.l10n!.requiredFieldError;
      }

      if (!emailRegExp.hasMatch(value)) {
        return context.l10n!.invalidFieldEmail;
      }
      return null;
    };
  }

  /// Returns a validator for password field.
  /// The validator checks if the value is not empty.
  static String? Function(String?) getPasswordValidator(BuildContext context) {
    return (value) {
      if (!_isFilled(value)) {
        return context.l10n!.requiredFieldError;
      }
      return null;
    };
  }

  /// Returns a validator for food name field.
  /// The validator checks if the value is not empty.
  static String? Function(String?) getFoodNameValidator(BuildContext context) {
    return (value) {
      if (!_isFilled(value)) {
        return context.l10n!.requiredFieldError;
      }
      return null;
    };
  }

  /// Returns a validator for food category field.
  /// The validator checks if the value is not empty.
  static String? Function(String?) getFoodCategoryValidator(
    BuildContext context,
  ) {
    return (value) {
      if (!_isFilled(value)) {
        return context.l10n!.invalidFieldFoodCategory;
      }
      return null;
    };
  }

  /// Returns a validator for box type field.
  /// The validator checks if the value is not empty.
  static String? Function(String?) getBoxTypeValidator(BuildContext context) {
    return (value) {
      if (!_isFilled(value)) {
        return context.l10n!.invalidFieldBoxType;
      }
      return null;
    };
  }

  /// Returns a validator for number of boxes field.
  /// The validator checks if the value is a number.
  static String? Function(String?) getBoxNumberValidator(BuildContext context) {
    return (value) {
      if (!_isNumber(value)) {
        return context.l10n!.invalidFieldBoxNumber;
      }
      return null;
    };
  }

  /// Returns a validator for number of servings field.
  /// The validator checks if the value is a number.
  static String? Function(String?) getServingsValidator(BuildContext context) {
    return (value) {
      if (!_isNumber(value)) {
        return context.l10n!.invalidFieldServings;
      }
      return null;
    };
  }

  /// Returns a validator for consume by field.
  /// The validator checks if the value is not empty.
  static String? Function(String?) getConsumeByValidator(BuildContext context) {
    return (value) {
      if (!_isFilled(value)) {
        return context.l10n!.invalidFieldConsumeBy;
      }
      return null;
    };
  }

  /// Wraps a validator and invokes a callback with the validation result.
  ///
  /// The [validator] is the original validator.
  /// The [onValidate] callback is invoked with `true` if the validation
  /// is successful, `false` otherwise.
  static String? Function(String?)? wrapValidator(
    String? Function(String?)? validator,
    Function(bool) onValidate,
  ) {
    if (validator == null) {
      return null;
    }

    return (value) {
      final error = validator(value);
      onValidate(error == null);
      return error;
    };
  }

  static bool _isFilled(String? value) {
    return value != null && value.isNotEmpty;
  }

  static bool _isNumber(String? value) {
    return value != null && int.tryParse(value) != null;
  }
}
