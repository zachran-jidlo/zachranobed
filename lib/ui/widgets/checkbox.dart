import 'package:flutter/material.dart';

class ZOCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;
  final String title;

  const ZOCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
  });

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
      title: Text(widget.title),
    );
  }
}
