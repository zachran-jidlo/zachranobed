import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A custom selectable chip widget.
class UiChip extends StatelessWidget {
  /// The text displayed on the chip.
  final String text;

  /// Whether the chip is currently selected. By default chip is unselected.
  final bool selected;

  /// Whether the chip is enabled or not. By default chip is enabled.
  final bool enabled;

  /// The callback function triggered when the chip is pressed.
  final VoidCallback onPressed;

  /// Creates a [UiChip] widget.
  const UiChip({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: _resolveStyle(context),
      child: Text(text),
    );
  }

  ButtonStyle _resolveStyle(BuildContext context) {
    final baseStyle = TextButton.styleFrom(
      minimumSize: Size(0, 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: context.textTheme.labelLarge,
      shadowColor: Colors.black,
    );

    if (selected) {
      return baseStyle.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return context.uiColors.surfaceGray;
          }
          if (states.contains(WidgetState.pressed)) {
            return context.uiColors.primaryDark;
          }
          if (states.contains(WidgetState.hovered)) {
            return context.uiColors.primary;
          }
          return context.uiColors.primaryDark;
        }),
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          if (states.contains(WidgetState.pressed)) {
            return 4.0;
          }
          if (states.contains(WidgetState.hovered)) {
            return 2.0;
          }
          return 0.0;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return context.uiColors.textSecondary;
          }
          return context.uiColors.surfaceWhite;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: context.uiColors.inactive);
          }
          return BorderSide.none;
        }),
      );
    } else {
      return baseStyle.copyWith(
        overlayColor: WidgetStateProperty.all(context.uiColors.surfaceGray),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return context.uiColors.inactive;
          }
          return context.uiColors.textPrimary;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: context.uiColors.inactive);
          }
          return BorderSide(color: context.uiColors.textPrimary);
        }),
      );
    }
  }
}
