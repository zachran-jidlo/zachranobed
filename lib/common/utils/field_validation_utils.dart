import 'package:flutter/cupertino.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/enums/food_category.dart';
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
        return context.l10n!.invalidFieldFoodName;
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
        return context.l10n!.invalidFieldFoodAllergens;
      }
      return null;
    };
  }

  /// Returns a validator for food category field.
  /// The validator checks if the value is set.
  static String? Function(FoodCategory?) getFoodCategoryValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null) {
        return context.l10n!.invalidFieldFoodCategory;
      }
      return null;
    };
  }

  /// Returns a validator for food temperature field.
  /// The validator checks if the value is in allowed range.
  static String? Function(int?) getFoodTemperatureValidator(BuildContext context) {
    return (value) {
      if (value == null) {
        return context.l10n!.requiredFieldError;
      }
      if (value < Constants.foodTemperatureMin) {
        return context.l10n!.invalidFieldFoodTemperatureTooLow;
      }
      if (value > Constants.foodTemperatureMax) {
        return context.l10n!.invalidFieldFoodTemperatureTooHigh;
      }
      return null;
    };
  }

  /// Returns a validator for number of boxes field.
  ///
  /// The validator checks if the input value is within the allowed range
  /// and returns an error message if it's invalid.
  ///
  /// [context] is used to access localization strings.
  /// [allowZero] determines if zero is a valid input. Defaults to false.
  /// [max] specifies the maximum allowed value.
  static String? Function(int?) getBoxNumberValidator(
    BuildContext context, {
    bool allowZero = false,
    int? max,
  }) {
    return (value) {
      if (max != null && (value == null || value > max)) {
        return context.l10n!.invalidFieldBoxNumberTooHigh;
      }
      if (!allowZero && (value == null || value <= 0)) {
        return context.l10n!.invalidFieldBoxNumber;
      }
      return null;
    };
  }

  /// Returns a validator for number of servings field.
  /// The validator checks if the value is a non-zero number.
  static String? Function(int?) getServingsValidator(BuildContext context) {
    return (value) {
      if (value == null || value <= 0) {
        return context.l10n!.invalidFieldServings;
      }
      return null;
    };
  }

  /// Returns a validator for number of packages field.
  /// The validator checks if the value is a non-zero number.
  static String? Function(int?) getPackagesValidator(BuildContext context) {
    return (value) {
      if (value == null || value <= 0) {
        return context.l10n!.invalidFieldPackages;
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

  /// Returns a validator for prepared at field.
  /// The validator checks if the value is set and date is not in the future.
  static String? Function(FoodDateTime?) getPreparedAtValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null) {
        return context.l10n!.invalidFieldPreparedAt;
      }
      final now = DateTime.now();
      if (value is FoodDateTimeSpecified && value.date.isAfter(now)) {
        return context.l10n!.invalidFieldPreparedAtDateInPast;
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
