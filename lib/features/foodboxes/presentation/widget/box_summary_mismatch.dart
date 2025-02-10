import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

/// A widget that displays information about a food box checkup mismatch. This widget shows a description about the
/// mismatch and displays the food box data in a table.
class BoxSummaryMismatch extends StatelessWidget {
  /// The widget with food boxes data in the table.
  final Widget boxTable;

  /// Creates a [BoxSummaryMismatch] widget.
  const BoxSummaryMismatch({
    super.key,
    required this.boxTable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n!.foodBoxesCheckupMismatchDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16.0),
        boxTable,
      ],
    );
  }
}
