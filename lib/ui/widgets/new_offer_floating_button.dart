import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes.dart';
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
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteManager.offerFood),
            elevation: 0,
            shape: const StadiumBorder(),
            backgroundColor: ZOColors.primaryLight,
            label: Text(
              AppLocalizations.of(context)!.newOffer,
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
                    title: '${AppLocalizations.of(context)!.newOffer}?',
                    content:
                        AppLocalizations.of(context)!.newOfferDialogContent,
                    confirmText: AppLocalizations.of(context)!.callACourier,
                    cancelText: AppLocalizations.of(context)!.cancel,
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
                  title: '${AppLocalizations.of(context)!.newOffer}?',
                  content: AppLocalizations.of(context)!
                      .cantOfferAnymoreDialogContent,
                  cancelText: AppLocalizations.of(context)!.cancel,
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
      AppLocalizations.of(context)!.deliveryConfirmedState,
    );
    if (context.mounted) {
      context.read<DeliveryNotifier>().updateDeliveryState(
          AppLocalizations.of(context)!.deliveryConfirmedState);
    }
  }
}
