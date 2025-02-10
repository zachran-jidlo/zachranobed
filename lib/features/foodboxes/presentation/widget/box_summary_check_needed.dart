import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary_card.dart';
import 'package:zachranobed/features/foodboxes/presentation/model/box_summary_status.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/content_with_loading.dart';

/// A card that displays the information that user should perform a food boxes checkup.
class BoxSummaryCheckNeeded extends StatelessWidget {
  /// Whether the widget is in a loading state.
  final bool isLoading;

  /// The status of the food boxes checkup.
  final CheckNeeded status;

  /// The callback function that is called when the user taps on the "Delay" button.
  final VoidCallback onDelayPressed;

  /// The callback function that is called when the user taps on the "Check" button.
  final VoidCallback onCheckPressed;

  /// Creates a [BoxSummaryCheckNeeded] widget.
  const BoxSummaryCheckNeeded({
    super.key,
    required this.isLoading,
    required this.status,
    required this.onDelayPressed,
    required this.onCheckPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ContentWithLoading(
      isLoading: isLoading,
      child: BoxSummaryCard(
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(ZOStrings.iconFoodBoxAlert),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n!.foodBoxesCheckupNeededCardTitle,
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        status.isDelayAvailable
                            ? context.l10n!.foodBoxesCheckupNeededCardDefaultDescription
                            : context.l10n!.foodBoxesCheckupNeededCardMandatoryDescription,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status.isDelayAvailable) ...[
                  ZOButton(
                    text: context.l10n!.foodBoxesCheckupNeededCardDelayAction,
                    onPressed: onDelayPressed,
                    type: ZOButtonType.textPrimary,
                    minimumSize: ZOButtonSize.medium(fullWidth: false),
                  ),
                  const SizedBox(width: 16.0),
                ],
                ZOButton(
                  text: context.l10n!.foodBoxesCheckupNeededCardCheckAction,
                  onPressed: onCheckPressed,
                  type: ZOButtonType.primary,
                  minimumSize: ZOButtonSize.medium(fullWidth: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
