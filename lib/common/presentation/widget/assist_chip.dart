import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A custom Assist Chip widget.
///
/// This widget is a customized version of [ActionChip] with specific styling
/// for selected and unselected states. It displays a text label and triggers
/// an action when pressed.
class AssistChip extends StatelessWidget {
  /// The text displayed on the chip.
  final String text;

  /// Whether the chip is currently selected. By default chips is unselected.
  final bool selected;

  /// The callback function triggered when the chip is pressed.
  final VoidCallback onPressed;

  /// Creates an [AssistChip] widget.
  const AssistChip({
    super.key,
    required this.text,
    required this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _AssistChipColors.fromSelected(selected);
    return ActionChip(
      label: Text(
        text,
        style: TextStyle(color: colors.textColor),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      backgroundColor: colors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: colors.borderColor,
          width: 1.0,
        ),
      ),
    );
  }
}

/// A class that holds the colors for the [AssistChip] widget.
class _AssistChipColors {
  /// The text color of the chip.
  final Color textColor;

  /// The background color of the chip.
  final Color backgroundColor;

  /// The border color of the chip.
  final Color borderColor;

  /// Creates an instance of [_AssistChipColors].
  const _AssistChipColors({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  /// Creates an instance of [_AssistChipColors] based on the selected state.
  factory _AssistChipColors.fromSelected(bool selected) {
    return selected
        ? const _AssistChipColors(
            textColor: ZOColors.onSecondary,
            backgroundColor: ZOColors.secondary,
            borderColor: ZOColors.onPrimaryLight,
          )
        : const _AssistChipColors(
            textColor: ZOColors.onPrimaryLight,
            backgroundColor: Colors.transparent,
            borderColor: ZOColors.outline,
          );
  }
}
