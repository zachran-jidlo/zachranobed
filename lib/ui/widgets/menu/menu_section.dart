import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class MenuSection extends StatelessWidget {
  final WidgetBuilder label;
  final List<Widget> menuItems;

  const MenuSection({
    super.key,
    required this.label,
    required this.menuItems,
  });

  MenuSection.simple({
    Key? key,
    required String label,
    required List<Widget> menuItems,
  }) : this(
          key: key,
          label: (context) => _label(context, label),
          menuItems: menuItems,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Builder(builder: label)]),
        const SizedBox(height: 8),
        for (var item in menuItems) item,
        const SizedBox(height: GapSize.m),
      ],
    );
  }

  static Widget _label(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
