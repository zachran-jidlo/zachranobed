import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';

/// A password text field widget with visibility toggle functionality.
///
/// This widget wraps [UiTextField] and adds a trailing icon button that allows
/// users to toggle between showing and hiding the password text.
class UiPasswordTextField extends StatefulWidget {
  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text displayed above the text field.
  final String? labelText;

  /// The hint text displayed when the text field is empty.
  final String? hintText;

  /// The supporting text displayed below the text field.
  final String? supportingText;

  /// The error text displayed below the text field.
  final String? errorText;

  /// Whether the text field is enabled or not. By default text field is enabled.
  final bool enabled;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.visiblePassword] for better password input UX.
  final TextInputType? keyboardType;

  /// The callback function triggered when the text changes.
  final ValueChanged<String>? onChanged;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The validation function for form validation.
  final String? Function(String?)? onValidation;

  /// The list of input formatters for restricting input.
  final List<TextInputFormatter>? textInputFormatters;

  /// The initial value for the text field.
  final String? initialValue;

  /// Whether the text field is read-only. By default text field is editable.
  final bool readOnly;

  /// The maximum number of lines for the text field.
  final int? maxLines;

  /// The minimum number of lines for the text field.
  final int? minLines;

  /// The action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The callback function triggered when the field is submitted.
  final ValueChanged<String>? onFieldSubmitted;

  /// A stable accessibility identifier for the input, used by UI tests.
  final String? semanticsIdentifier;

  /// Creates a [UiPasswordTextField] widget.
  const UiPasswordTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.supportingText,
    this.errorText,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.onValidation,
    this.textInputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onFieldSubmitted,
    this.semanticsIdentifier,
  }) : assert(
          controller == null || initialValue == null,
          'Cannot provide both controller and initialValue',
        );

  @override
  State<UiPasswordTextField> createState() => _UiPasswordTextFieldState();
}

class _UiPasswordTextFieldState extends State<UiPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      supportingText: widget.supportingText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      onValidation: widget.onValidation,
      textInputFormatters: widget.textInputFormatters,
      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      disableAutocorrect: true,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      semanticsIdentifier: widget.semanticsIdentifier,
      trailingIcon: _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      onTrailingIconPressed: _toggleVisibility,
    );
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
