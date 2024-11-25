import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/math_utils.dart';
import 'package:zachranobed/ui/widgets/counter_button.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

/// A widget that combines a text field with increment and decrement buttons
/// for entering numeric values. This widget allows users to enter a numeric
/// value within a specified range using a text field. It also provides
/// increment and decrement buttons to adjust the value easily.
class CounterField extends StatefulWidget {
  /// The label displayed above the text field.
  final String label;

  /// The initial value of the counter.
  final int initialValue;

  /// The minimum allowed value for the counter.
  final int minValue;

  /// The maximum allowed value for the counter.
  final int maxValue;

  /// The value which is set when user clears the value from text field.
  final int noValueFallback;

  /// Signature for validating a form field.
  final String? Function(int)? onValidation;

  /// Callback function triggered when the counter value changes.
  final Function(int)? onChanged;

  /// Supporting text displayed below the text field.
  final String? supportingText;

  /// Focus node for the widget.
  final FocusNode? focusNode;

  /// Creates a new [CounterField] instance.
  const CounterField({
    Key? key,
    required this.label,
    required this.initialValue,
    this.minValue = 0,
    this.maxValue = intMax,
    this.noValueFallback = 0,
    this.onValidation,
    this.onChanged,
    this.supportingText,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.minValue, widget.maxValue);
    _controller = TextEditingController(text: _currentValue.toString());

    // Updates a counter value when field loses focus, using parsed text or
    // initial value.
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final counterValue = _getCounterValue(_controller.text);
        _updateValue(counterValue);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ZOTextField(
            label: widget.label,
            controller: _controller,
            onValidation: (value) {
              final counterValue = _getCounterValue(value);
              return widget.onValidation?.call(counterValue);
            },
            onChanged: (value) {
              final counter = int.tryParse(value);
              if (counter != null) {
                _updateValue(counter);
              }
            },
            inputType: TextInputType.number,
            textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
            focusNode: _focusNode,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _actions(),
          ),
        )
      ],
    );
  }

  Widget _actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CounterButton(
          type: CounterButtonType.decrement,
          onPressed: _currentValue > widget.minValue ? _decrement : null,
        ),
        const SizedBox(width: GapSize.m),
        // Increase button
        CounterButton(
          type: CounterButtonType.increment,
          onPressed: _currentValue < widget.maxValue ? _increment : null,
        ),
      ],
    );
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
    setState(() {
      _currentValue = value;
      final textValue = value.toString();
      if (_controller.text != textValue) {
        _controller.text = textValue;
      }
      widget.onChanged?.call(value);
    });
  }

  int _getCounterValue(String? value) =>
      int.tryParse(value ?? "") ?? widget.noValueFallback;
}
