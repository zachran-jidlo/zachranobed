import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/domain/utils/math_utils.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_fill_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/ui_text_field.dart';

/// A text field with increment/decrement buttons for entering numeric values.
///
/// This widget allows users to enter a numeric value within a specified range
/// using a text field. It also provides increment and decrement buttons to
/// adjust the value easily.
class UiCounterField extends StatefulWidget {
  /// The label for the text field.
  final String label;

  /// The current value of the counter.
  final int value;

  /// The minimum allowed value for the counter.
  final int minValue;

  /// The maximum allowed value for the counter.
  final int maxValue;

  /// The value which is set when user clears the value from text field.
  final int noValueFallback;

  /// Callback function triggered when the counter value changes.
  final ValueChanged<int> onChanged;

  /// Optional validation function for the counter value.
  final String? Function(int)? onValidation;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Whether the field is enabled or not.
  final bool enabled;

  /// Creates a [UiCounterField] widget.
  const UiCounterField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = intMax,
    this.noValueFallback = 0,
    this.onValidation,
    this.focusNode,
    this.enabled = true,
  });

  @override
  State<UiCounterField> createState() => _UiCounterFieldState();
}

class _UiCounterFieldState extends State<UiCounterField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value.clamp(widget.minValue, widget.maxValue);
    _controller = TextEditingController(text: _currentValue.toString());

    // Updates a counter value when field loses focus, using parsed text or
    // noValueFallback.
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final counterValue = _getCounterValue(_controller.text);
        _updateValue(counterValue);
      }
    });
  }

  @override
  void didUpdateWidget(UiCounterField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value.clamp(widget.minValue, widget.maxValue);

      final textValue = _currentValue.toString();
      if (_controller.text != textValue) {
        _controller.text = textValue;
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.0,
      children: [
        Expanded(
          child: UiTextField(
            controller: _controller,
            labelText: widget.label,
            keyboardType: TextInputType.number,
            textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enabled: widget.enabled,
            onChanged: _handleTextFieldChange,
            onValidation: _wrapValidation,
            focusNode: _focusNode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            spacing: 24.0,
            children: [
              UiIconOutlineButton(
                icon: Icons.remove,
                enabled: widget.enabled && _currentValue > widget.minValue,
                onPressed: _decrement,
              ),
              UiIconFillButton(
                icon: Icons.add,
                enabled: widget.enabled && _currentValue < widget.maxValue,
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleTextFieldChange(String value) {
    final parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      _updateValue(parsedValue);
    }
  }

  String? _wrapValidation(String? value) {
    final parsedValue = _getCounterValue(value);
    return widget.onValidation?.call(parsedValue);
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      _updateValue(_currentValue + 1);
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      _updateValue(_currentValue - 1);
    }
  }

  void _updateValue(int value) {
    if (!mounted) {
      return;
    }

    final clampedValue = value.clamp(widget.minValue, widget.maxValue);

    setState(() {
      _currentValue = clampedValue;
      final textValue = clampedValue.toString();
      if (_controller.text != textValue) {
        _controller.text = textValue;
      }
    });

    widget.onChanged(clampedValue);
  }

  int _getCounterValue(String? value) => int.tryParse(value ?? "") ?? widget.noValueFallback;
}
