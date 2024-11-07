/// The enumeration represents the different types of fields that can be
/// included in a food donation form. Used to create a key for
/// [FormValidationManager].
enum FormFieldType {
  foodName,
  allergens,
  foodCategory,
  temperature,
  numberOfServings,
  numberOfBoxes,
  boxType,
  preparedAt,
  consumeBy,
}

/// Extension on [FormFieldType] to generate a unique key for each form field.
extension FormFieldTypeExtension on FormFieldType {
  String createFormFieldKey(int index) {
    return "form$index-field${this.name.toUpperCase()}";
  }
}
