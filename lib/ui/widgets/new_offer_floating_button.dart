import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/delivery_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';

class NewOfferFloatingButton extends StatelessWidget {
  final bool enabled;

  const NewOfferFloatingButton({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return enabled
        ? FloatingActionButton.extended(
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteManager.offerFood),
            elevation: 0,
            shape: const StadiumBorder(),
            backgroundColor: ZachranObedColors.primaryLight,
            label: const Text(
              ZachranObedStrings.newOffer,
              style: TextStyle(color: ZachranObedColors.primary),
            ),
            icon: const Icon(
              MaterialSymbols.add,
              color: ZachranObedColors.primary,
            ),
          )
        : FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                if (HelperService.canDonate(context)) {
                  return ZachranObedDialog(
                    title: '${ZachranObedStrings.newOffer}?',
                    content: ZachranObedStrings.newOfferDialogContent,
                    confirmText: ZachranObedStrings.callACourier,
                    cancelText: ZachranObedStrings.cancel,
                    icon: Icons.directions_car_filled_outlined,
                    onConfirmPressed: () async {
                      await _callACourier(context);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    onCancelPressed: () => Navigator.of(context).pop(false),
                  );
                }
                return ZachranObedDialog(
                  title: '${ZachranObedStrings.newOffer}?',
                  content: ZachranObedStrings.cantOfferAnymoreDialogContent,
                  cancelText: ZachranObedStrings.cancel,
                  icon: Icons.edit_calendar_outlined,
                  onCancelPressed: () => Navigator.of(context).pop(false),
                );
              },
            ),
            elevation: 0,
            shape: const StadiumBorder(),
            backgroundColor: ZachranObedColors.primaryLight,
            child: const Icon(
              MaterialSymbols.add,
              color: ZachranObedColors.disabledButtonChild,
            ),
          );
  }

  Future<void> _callACourier(BuildContext context) async {
    await DeliveryApiService().updateDeliveryStatus(
      context.read<DeliveryNotifier>().delivery!.internalId,
      ZachranObedStrings.deliveryConfirmedState,
    );
    if (context.mounted) {
      context
          .read<DeliveryNotifier>()
          .updateDeliveryState(ZachranObedStrings.deliveryConfirmedState);
    }
  }
}
