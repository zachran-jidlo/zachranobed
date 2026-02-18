import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';

/// A banner widget displayed when a food boxes mismatch has been reported.
class FoodBoxesCheckupTileMismatch extends StatelessWidget {
  /// Creates a [FoodBoxesCheckupTileMismatch] widget.
  const FoodBoxesCheckupTileMismatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UiNotificationTile(
      title: context.l10n.foodBoxesCheckupMismatchTitle,
      icon: Icons.warning_rounded,
      iconColor: context.uiColors.warning,
      trailing: UiIconButton.gradient(
        icon: Icons.info_outline,
        onPressed: () => _showMismatchInfo(context),
      ),
    );
  }

  void _showMismatchInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.foodBoxesCheckupMismatchTitle,
        content: context.l10n.foodBoxesCheckupMismatchDescription,
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
