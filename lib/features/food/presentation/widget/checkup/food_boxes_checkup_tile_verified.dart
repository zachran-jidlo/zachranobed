import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';

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
      trailing: UiIconButton.gradient(
        icon: Icons.info_outline,
        onPressed: () => _showVerifiedInfo(context),
      ),
    );
  }

  void _showVerifiedInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.foodBoxesCheckupVerifiedTitle,
        content: context.l10n.foodBoxesCheckupVerifiedDescription,
        titleAlign: TextAlign.center,
        icon: UiIcon(
          spec: UiIconSpec.data(Icons.info_outline),
          color: context.uiColors.textPrimary,
        ),
        actions: [
          UiPrimaryButton(
            text: context.l10n.commonClose,
            onPressed: () => context.router.maybePop(),
          ),
        ],
      ),
    );
  }
}
