import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/ui/widgets/supporting_text.dart';

class ZOTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? onValidation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? supportingText;
  final bool readOnly;
  final FocusNode? focusNode;
  final bool disableAutocorrect;

  const ZOTextField({
    super.key,
    required this.label,
    this.controller,
    this.onValidation,
    this.inputType,
    this.textInputFormatters,
    this.onChanged,
    this.initialValue,
    this.supportingText,
    this.readOnly = false,
    this.focusNode,
    this.disableAutocorrect = false,
  });

  @override
  State<ZOTextField> createState() => _ZOTextFieldState();
}

class _ZOTextFieldState extends State<ZOTextField> {
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    var internalFocusNode = widget.focusNode ?? FocusNode();

    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          cursorColor: Colors.black,
          validator: FieldValidationUtils.wrapValidator(
            widget.onValidation,
            (isValid) {
              setState(() {
                _isValid = isValid;
              });
            },
          ),
          keyboardType: widget.inputType,
          inputFormatters: widget.textInputFormatters,
          onChanged: widget.onChanged,
          decoration: WidgetStyle.createInputDecoration(
            label: widget.label,
            isValid: _isValid,
          ),
          initialValue: widget.initialValue,
          focusNode: internalFocusNode,
          onTapOutside: (event) => internalFocusNode.unfocus(),
          readOnly: widget.readOnly,
          autocorrect: !widget.disableAutocorrect,
          spellCheckConfiguration: widget.disableAutocorrect
              ? const SpellCheckConfiguration.disabled()
              : null,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        widget.supportingText != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidgetStyle.padding,
                ),
                child: SupportingText(text: widget.supportingText!),
              )
            : const SizedBox(),
      ],
    );
  }
}
