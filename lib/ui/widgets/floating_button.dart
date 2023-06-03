import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ZachranObedFloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const StadiumBorder(),
      backgroundColor: ZachranObedColors.primaryLight,
      child: const Icon(
        MaterialSymbols.add,
        color: ZachranObedColors.primary,
      ),
    );
  }
}
