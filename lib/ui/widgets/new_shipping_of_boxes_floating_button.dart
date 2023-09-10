import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';

class NewShippingOfBoxesFloatingButton extends StatelessWidget {
  const NewShippingOfBoxesFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.router.push(const OrderShippingOfBoxesRoute()),
      elevation: 0,
      shape: const StadiumBorder(),
      backgroundColor: ZOColors.primaryLight,
      label: Text(
        context.l10n!.shippingOfBoxes,
        style: const TextStyle(color: ZOColors.primary),
      ),
      icon: const Icon(
        MaterialSymbols.add,
        color: ZOColors.primary,
      ),
    );
  }
}
