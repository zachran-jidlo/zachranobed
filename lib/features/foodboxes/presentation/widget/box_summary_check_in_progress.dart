import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/content_with_loading.dart';

/// A widget that displays information about a food box checkup that is currently in progress.
class BoxSummaryCheckInProgress extends StatelessWidget {
  /// Whether the widget is in a loading state.
  final bool isLoading;

  /// The widget with food boxes data in the table.
  final Widget boxTable;

  /// The callback function that is called when the user taps on the "Mismatches" button.
  final VoidCallback onMismatchesPressed;

  /// The callback function that is called when the user taps on the "Matches" button.
  final VoidCallback onMatchesPressed;

  /// Creates a [BoxSummaryCheckInProgress] widget.
  const BoxSummaryCheckInProgress({
    super.key,
    required this.isLoading,
    required this.boxTable,
    required this.onMismatchesPressed,
    required this.onMatchesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        boxTable,
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              context.l10n!.foodBoxesCheckupInProgressDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ZOColors.onCardBackground),
            ),
          ),
        ),
        ContentWithLoading(
          isLoading: isLoading,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ZOButton(
                text: context.l10n!.foodBoxesCheckupInProgressMismatchesAction,
                onPressed: onMismatchesPressed,
                type: ZOButtonType.tertiary,
                minimumSize: ZOButtonSize.medium(fullWidth: false),
              ),
              const SizedBox(width: 16.0),
              ZOButton(
                text: context.l10n!.foodBoxesCheckupInProgressMatchesAction,
                onPressed: onMatchesPressed,
                type: ZOButtonType.primary,
                minimumSize: ZOButtonSize.medium(fullWidth: false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
