import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

import '../../enums/food_form_field_type.dart';
import 'form/form_validation_manager.dart';

class FoodAllergensTextField extends StatefulWidget {
  final int index;
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final FormValidationManager formValidationManager;

  const FoodAllergensTextField({
    super.key,
    required this.index,
    required this.label,
    required this.onChanged,
    required this.formValidationManager,
    this.initialValue,
  });

  @override
  _FoodAllergensTextFieldState createState() => _FoodAllergensTextFieldState();
}

class _FoodAllergensTextFieldState extends State<FoodAllergensTextField> {
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    String _formFieldKey =
        FormFieldType.allergens.createFormFieldKey(widget.index);
    return ZOTextField(
      label: widget.label,
      focusNode: widget.formValidationManager.getFocusNode(_formFieldKey),
      onValidation: widget.formValidationManager.wrapValidator(
        _formFieldKey,
        (val) {
          RegExp allergensRegex =
              RegExp(r'^(1[0-4]|[1-9])(,\s*(1[0-4]|[1-9]))*$');
          if (val!.isEmpty || !allergensRegex.hasMatch(val)) {
            setState(() {
              _isValid = false;
            });
            return context.l10n!.allergensSupportingText;
          } else {
            setState(() {
              _isValid = true;
            });
            return null;
          }
        },
      ),
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      supportingText: _isValid ? context.l10n!.allergensSupportingText : null,
    );
  }
}
