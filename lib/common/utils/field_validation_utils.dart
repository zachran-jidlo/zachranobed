import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';

/// Provides utility methods for field validation.
class FieldValidationUtils {
  FieldValidationUtils._();

  /// Regular expression for validating an email address.
  static RegExp emailRegExp = RegExp(
      "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+");

  /// Regular expression for validating a password.
  /// Explanation: Any sequence of at least 8 characters.
  static RegExp passwordRegExp = RegExp(".{8,}");

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

  /// Returns a validator for new password field.
  /// The validator checks if the value is not empty and has enough length.
  static String? Function(String?) getNewPasswordValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return context.l10n!.requiredFieldError;
      }
      if (!passwordRegExp.hasMatch(value)) {
        return context.l10n!.passwordLengthError;
      }
      return null;
    };
  }

  /// Returns a validator for repeat new password field.
  /// The validator checks if the value is not empty and matches new password.
  static String? Function(String?) getRepeatNewPasswordValidator(
    BuildContext context,
    TextEditingController newPasswordController,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return context.l10n!.requiredFieldError;
      }
      if (value != newPasswordController.text) {
        return context.l10n!.passwordsDontMatchError;
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

  /// Returns a validator for food allergens chips.
  /// The validator checks if at least some value is selected.
  static String? Function(List<String>?) getFoodAllergensValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
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
  /// The validator checks if the value is set and date is not in the past.
  static String? Function(FoodDateTime?) getConsumeByValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null) {
        return context.l10n!.invalidFieldConsumeBy;
      }
      final now = DateTime.now();
      if (value is FoodDateTimeSpecified && value.date.isBefore(now)) {
        return context.l10n!.invalidFieldConsumeByDateInPast;
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
