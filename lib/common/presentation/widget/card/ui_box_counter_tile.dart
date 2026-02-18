import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';

/// A tile widget that displays box information with an editable counter.
///
/// This widget shows a card with a title, subtitle, and a counter field slot.
class UiBoxCounterTile extends StatelessWidget {
  /// The name of the box type.
  final String title;

  /// Subtitle displayed below the title.
  final String subtitle;

  /// The counter field widget.
  final UiCounterField counterField;

  /// Creates a [UiBoxCounterTile] widget.
  const UiBoxCounterTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.counterField,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Container(
            color: context.uiColors.surfaceGray,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: counterField,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          Text(
            title,
            style: context.textStyles.titleLarge.copyWith(
              color: context.uiColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
