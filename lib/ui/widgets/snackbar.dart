import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

double _HEIGHT = 48.0;

class ZOSnackBar extends StatelessWidget {
  final String message;

  const ZOSnackBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      height: _HEIGHT,
      decoration: ShapeDecoration(
        color: ZOColors.infoSnackBarBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        shadows: const [
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 3,
          )
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(color: ZOColors.onInfoSnackBarBackground),
      ),
    );
  }
}
