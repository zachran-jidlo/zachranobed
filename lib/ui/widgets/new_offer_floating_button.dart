import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';

class NewOfferFloatingButton extends StatelessWidget {
  const NewOfferFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    final delivery = context.watch<DeliveryNotifier>().delivery;

    if (!HelperService.canDonate(context)) {
      return _buildCantOfferAnymoreButton(context);
    }

    switch (delivery?.state) {
      case DeliveryState.accepted:
      case DeliveryState.offered:
        if (user is Canteen && user.isCurrentTimeWithinPickupRange()) {
          return _buildNewOfferButton(context);
        } else {
          return _buildCantOfferAnymoreButton(context);
        }
      default:
        return _buildCallACourierButton(context);
    }
  }

  Widget _buildNewOfferButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.router.push(const OfferFoodRoute()),
      elevation: 0,
      shape: const StadiumBorder(),
      backgroundColor: ZOColors.primaryLight,
      label: Text(
        context.l10n!.newOffer,
        style: const TextStyle(color: ZOColors.primary),
      ),
      icon: const Icon(
        MaterialSymbols.add,
        color: ZOColors.primary,
      ),
    );
  }

  Widget _buildCallACourierButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ZODialog(
          title: '${context.l10n!.newOffer}?',
          content: context.l10n!.newOfferDialogContent,
          confirmText: context.l10n!.callACourier,
          cancelText: context.l10n!.cancel,
          onConfirmPressed: () async {
            context.read<DeliveryNotifier>().updateDeliveryState(DeliveryState.accepted);
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          onCancelPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      elevation: 0,
      shape: const StadiumBorder(),
      backgroundColor: ZOColors.primaryLight,
      child: const Icon(
        MaterialSymbols.add,
        color: ZOColors.disabledButtonChild,
      ),
    );
  }

  Widget _buildCantOfferAnymoreButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ZODialog(
          title: '${context.l10n!.newOffer}?',
          content: context.l10n!.cantOfferAnymoreDialogContent,
          cancelText: context.l10n!.cancel,
          onCancelPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      elevation: 0,
      shape: const StadiumBorder(),
      backgroundColor: ZOColors.primaryLight,
      child: const Icon(
        MaterialSymbols.add,
        color: ZOColors.disabledButtonChild,
      ),
    );
  }
}
