import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ZachranObedFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
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
    );
  }
}
