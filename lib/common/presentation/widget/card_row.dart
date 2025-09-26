import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

/// A widget that displays a row of information within a card-like container.
class CardRow extends StatelessWidget {
  /// An optional label displayed above the title.
  final String? label;

  /// The title of the row.
  final String title;

  /// An optional subtitle displayed below the title.
  final WidgetBuilder? subtitle;

  /// An optional action widget displayed at the end of the row.
  final WidgetBuilder? action;

  /// Creates a [CardRow] widget.
  const CardRow({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZOColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetStyle.padding,
          vertical: WidgetStyle.paddingSmall,
        ),
        child: Row(
          children: [
            Expanded(
              child: _rowContent(context),
            ),
            if (action != null) Builder(builder: action!),
          ],
        ),
      ),
    );
  }

  /// Builds the content of the row, including the label, title, and subtitle.
  Widget _rowContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            children: [
              Text(
                label!,
                style: textTheme.labelMedium?.copyWith(
                  color: ZOColors.onPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        Text(
          title,
          style: textTheme.titleMedium,
        ),
        if (subtitle != null)
          Column(
            children: [
              const SizedBox(height: 4),
              Builder(builder: subtitle!),
            ],
          ),
      ],
    );
  }
}
