import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a section header with an optional action.
///
/// This widget is typically used to visually separate sections of content
/// and provide a title for each section. It can also include an optional
/// subtitle and action icon with an associated callback.
class SectionHeader extends StatelessWidget {
  /// The title displayed in the header.
  final Widget title;

  /// The subtitle displayed in the header.
  final Widget? subtitle;

  /// An optional widget representing the action.
  final Widget? action;

  /// The flag which determines whether to use bottom padding.
  final bool useBottomPadding;

  /// Creates a [SectionHeader] widget.
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.useBottomPadding = true,
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
        padding: EdgeInsets.only(bottom: useBottomPadding ? GapSize.xs : 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  subtitle ?? const SizedBox(),
                ],
              ),
            ),
            action ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SectionHeaderIcon extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const SectionHeaderIcon({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
