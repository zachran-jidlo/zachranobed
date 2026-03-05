import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A widget that displays a section header with an optional action.
///
/// This widget is typically used to visually separate sections of content
/// and provide a title for each section.
class SectionHeader extends StatelessWidget {
  /// The title displayed in the header.
  final String title;

  /// An optional widget representing the action.
  final Widget? action;

  /// Creates a [SectionHeader] widget.
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: context.uiColors.inactive),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textStyles.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          action ?? const SizedBox(height: 48),
        ],
      ),
    );
  }
}
