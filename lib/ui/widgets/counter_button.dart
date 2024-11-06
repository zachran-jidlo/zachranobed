import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A button used to increment or decrement a counter. The button's appearance
/// is determined by the [type] property.
class CounterButton extends StatelessWidget {
  static const _highlightAlpha = 100;

  /// The type of counter button.
  final CounterButtonType type;

  /// The callback triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// Creates a new [CounterButton] instance.
  const CounterButton({
    Key? key,
    required this.type,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(getIcon()),
      style: getButtonStyle(),
      onPressed: onPressed,
    );
  }

  /// Returns the icon to be displayed on the button based on the [type].
  IconData getIcon() {
    switch (type) {
      case CounterButtonType.increment:
        return Icons.add;
      case CounterButtonType.decrement:
        return Icons.remove;
    }
  }

  /// Returns the button style based on the [type].
  ButtonStyle getButtonStyle() {
    switch (type) {
      case CounterButtonType.increment:
        return IconButton.styleFrom(
          backgroundColor: ZOColors.primary,
          foregroundColor: ZOColors.onPrimary,
          disabledBackgroundColor: ZOColors.disabledButtonBackground,
          disabledForegroundColor: ZOColors.disabledButtonForeground,
          highlightColor: ZOColors.onPrimary.withAlpha(_highlightAlpha),
        );
      case CounterButtonType.decrement:
        return ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return ZOColors.disabledButtonForeground;
            } else {
              return ZOColors.onPrimaryLight;
            }
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: ZOColors.disabledButtonBackground);
            } else {
              return const BorderSide(color: ZOColors.outline);
            }
          }),
        );
    }
  }
}

/// Enumeration of types for counter button.
enum CounterButtonType {
  /// Represents an increment button.
  increment,

  /// Represents a decrement button.
  decrement,
}
