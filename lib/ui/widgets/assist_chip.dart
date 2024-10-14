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
    return ActionChip(
      label: Text(text),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      backgroundColor:
          selected ? ZOColors.assistChipSelectedBackground : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: selected ? Colors.black : ZOColors.outline,
          width: 1.0,
        ),
      ),
    );
  }
}
