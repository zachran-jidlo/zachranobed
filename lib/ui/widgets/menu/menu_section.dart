import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class MenuSection extends StatelessWidget {
  final String label;
  final List<Widget> menuItems;

  const MenuSection({
    super.key,
    required this.label,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text(label, style: const TextStyle(fontSize: FontSize.s))],
        ),
        for (var item in menuItems) item,
        const SizedBox(height: GapSize.m),
      ],
    );
  }
}
