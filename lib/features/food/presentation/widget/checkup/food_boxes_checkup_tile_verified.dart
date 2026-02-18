import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';

/// A badge widget displayed when food boxes have been verified.
class FoodBoxesCheckupTileVerified extends StatelessWidget {
  /// Creates a [FoodBoxesCheckupTileVerified] widget.
  const FoodBoxesCheckupTileVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return UiNotificationTile(
      title: context.l10n.foodBoxesCheckupVerifiedLabel,
      icon: Icons.check_rounded,
      iconColor: context.uiColors.success,
    );
  }
}
