import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';

class ZODropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? Function(String?)? onValidation;
  final Function(String) onChanged;
  final String? initialValue;
  final FocusNode? focusNode;

  const ZODropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onValidation,
    required this.onChanged,
    this.initialValue,
    this.focusNode,
  });

  @override
  State<ZODropdown> createState() => _ZODropdownState();
}

class _ZODropdownState extends State<ZODropdown> {
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (tap) {
        // Force remove focus when dropdown menu is collapsed
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: DropdownButtonFormField(
        isExpanded: true,
        validator: FieldValidationUtils.wrapValidator(
          widget.onValidation,
          (isValid) {
            setState(() {
              _isValid = isValid;
            });
          },
        ),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            widget.onChanged(value!);
          });
        },
        value: widget.initialValue,
        decoration: WidgetStyle.createInputDecoration(
          label: widget.hintText,
          isValid: _isValid,
        ),
        focusNode: widget.focusNode,
      ),
    );
  }
}
