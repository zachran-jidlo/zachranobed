import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class RemoveSectionButton extends StatelessWidget {
  final Function()? onClick;

  const RemoveSectionButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: 35.0,
        height: 35.0,
        decoration: BoxDecoration(
          color: ZOColors.secondary,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: ZOColors.onSecondary,
          size: 20.0,
        ),
      ),
    );
  }
}
