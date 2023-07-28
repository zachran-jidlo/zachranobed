import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';

class NewOfferFloatingButton extends StatelessWidget {
  final bool enabled;

  final _deliveryService = GetIt.I<DeliveryService>();

  NewOfferFloatingButton({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return enabled
        ? FloatingActionButton.extended(
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
          )
        : FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                if (HelperService.canDonate(context)) {
                  return ZODialog(
                    title: '${context.l10n!.newOffer}?',
                    content: context.l10n!.newOfferDialogContent,
                    confirmText: context.l10n!.callACourier,
                    cancelText: context.l10n!.cancel,
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
                return ZODialog(
                  title: '${context.l10n!.newOffer}?',
                  content: context.l10n!.cantOfferAnymoreDialogContent,
                  cancelText: context.l10n!.cancel,
                  icon: Icons.edit_calendar_outlined,
                  onCancelPressed: () => Navigator.of(context).pop(false),
                );
              },
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

  Future<void> _callACourier(BuildContext context) async {
    await _deliveryService.updateDeliveryStatus(
      context.read<DeliveryNotifier>().delivery!.id,
      context.l10n!.deliveryConfirmedState,
    );
    if (context.mounted) {
      context
          .read<DeliveryNotifier>()
          .updateDeliveryState(context.l10n!.deliveryConfirmedState);
    }
  }
}
