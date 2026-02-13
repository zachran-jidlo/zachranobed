import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/ui_notification_tile.dart';

/// A banner widget displayed when food boxes checkup is needed.
class FoodBoxesCheckupTileCheckNeeded extends StatelessWidget {
  /// Whether the delay action is available.
  final bool isDelayAvailable;

  /// Callback when delay action is triggered.
  final VoidCallback onDelayPressed;

  /// Callback when check action is triggered.
  final VoidCallback onCheckPressed;

  /// Creates a [FoodBoxesCheckupTileCheckNeeded] widget.
  const FoodBoxesCheckupTileCheckNeeded({
    super.key,
    required this.isDelayAvailable,
    required this.onDelayPressed,
    required this.onCheckPressed,
  });

  @override
  Widget build(BuildContext context) {
    final description = isDelayAvailable
        ? context.l10n.foodBoxesCheckupNeededCardDefaultDescription
        : context.l10n.foodBoxesCheckupNeededCardMandatoryDescription;

    return UiNotificationTile(
      title: context.l10n.foodBoxesCheckupNeededCardTitle,
      description: description,
      icon: Icons.warning_rounded,
      actions: [
        Row(
          spacing: 8.0,
          children: [
            if (isDelayAvailable)
              Expanded(
                child: UiOutlineButton(
                  size: UiButtonSize.medium(fullWidth: true),
                  text: context.l10n.foodBoxesCheckupNeededCardDelayAction,
                  onPressed: onDelayPressed,
                ),
              ),
            Expanded(
              child: UiPrimaryButton(
                size: UiButtonSize.medium(fullWidth: true),
                text: context.l10n.foodBoxesCheckupNeededCardCheckAction,
                onPressed: onCheckPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
