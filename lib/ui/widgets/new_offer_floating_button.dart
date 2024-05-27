import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';

class NewOfferFloatingButton extends StatelessWidget {
  final List<DeliveryState> enabledStates = [
    DeliveryState.accepted,
    DeliveryState.offered,
  ];

  NewOfferFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<DeliveryNotifier>().delivery;

    return enabledStates.contains(delivery?.state)
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
                    onConfirmPressed: () async {
                      context
                          .read<DeliveryNotifier>()
                          .updateDeliveryState(DeliveryState.accepted);
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
}
