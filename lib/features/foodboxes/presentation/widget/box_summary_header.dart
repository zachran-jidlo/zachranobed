import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/static_badge.dart';

/// A widget that displays a header in the food boxes summary widget.
class BoxSummaryHeader extends StatelessWidget {
  /// Whether the "verified" label should be displayed or not.
  final bool isVerified;

  /// Creates a [BoxSummaryHeader] widget.
  const BoxSummaryHeader({
    super.key,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n!.boxStatisticsHeader,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        AnimatedOpacity(
          opacity: isVerified ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: StaticBadge(
            text: context.l10n!.foodBoxesCheckupVerifiedLabel,
            icon: Icons.check,
          ),
        ),
      ],
    );
  }
}
