import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/supporting_text.dart';

class ZOTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? onValidation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? supportingText;
  final bool readOnly;

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
  });

  @override
  Widget build(BuildContext context) {
    var focus = FocusNode();

    return Column(
      children: [
        TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          validator: onValidation,
          keyboardType: inputType,
          inputFormatters: textInputFormatters,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: WidgetStyle.inputBorder,
            focusedBorder: WidgetStyle.inputBorder,
          ),
          initialValue: initialValue,
          focusNode: focus,
          onTapOutside: (event) => focus.unfocus(),
          readOnly: readOnly,
        ),
        supportingText != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidgetStyle.padding,
                ),
                child: SupportingText(text: supportingText!),
              )
            : const SizedBox(),
      ],
    );
  }
}
