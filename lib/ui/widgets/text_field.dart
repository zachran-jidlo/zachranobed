import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
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
  Widget build(BuildContext context) {
    var internalFocusNode = focusNode ?? FocusNode();

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
            errorMaxLines: 2,
          ),
          initialValue: initialValue,
          focusNode: internalFocusNode,
          onTapOutside: (event) => internalFocusNode.unfocus(),
          readOnly: readOnly,
          autocorrect: !disableAutocorrect,
          spellCheckConfiguration: disableAutocorrect ? const SpellCheckConfiguration.disabled() : null,
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
