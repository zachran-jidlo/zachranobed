import 'package:flutter/material.dart';

class ZOCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Widget titleWidget;

  const ZOCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.titleWidget,
  }) : super(key: key);

  factory ZOCheckbox.plain({
    Key? key,
    required bool isChecked,
    required Function(bool?)? onChanged,
    required String title,
  }) {
    return ZOCheckbox(
      key: key,
      isChecked: isChecked,
      onChanged: onChanged,
      titleWidget: Text(title),
    );
  }

  const ZOCheckbox.rich({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.titleWidget,
  }) : super(key: key);

  @override
  State<ZOCheckbox> createState() => _ZOCheckboxState();
}

class _ZOCheckboxState extends State<ZOCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.isChecked,
      onChanged: widget.onChanged,
      title: widget.titleWidget,
    );
  }
}
