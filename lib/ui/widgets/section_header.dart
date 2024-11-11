import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a section header with an optional action.
///
/// This widget is typically used to visually separate sections of content
/// and provide a title for each section. It can also include an optional
/// action icon with an associated callback.
class SectionHeader extends StatelessWidget {
  /// The text displayed in the header.
  final String text;

  /// An optional icon to display as an action.
  final Icon? actionIcon;

  /// The callback function triggered when the action icon is pressed.
  final VoidCallback? onActionPressed;

  /// Creates a [SectionHeader] widget.
  const SectionHeader({
    super.key,
    required this.text,
    this.actionIcon,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: ZOColors.secondary),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: GapSize.xs),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildAction(actionIcon, onActionPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(Icon? icon, VoidCallback? onPressed) {
    if (icon == null || onPressed == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(width: GapSize.xs),
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: icon,
            onPressed: onPressed,
            color: ZOColors.primary,
          ),
        ),
      ],
    );
  }
}
