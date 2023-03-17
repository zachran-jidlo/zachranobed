import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedCheckbox extends StatefulWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool> onChange;

  const ZachranObedCheckbox({
    Key? key,
    required this.text,
    required this.isChecked,
    required this.onChange,
  }) : super(key: key);

  @override
  State<ZachranObedCheckbox> createState() => _ZachranObedCheckboxState();
}

class _ZachranObedCheckboxState extends State<ZachranObedCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.text),
      activeColor: ZachranObedColors.primaryLight,
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
        });
        widget.onChange(value!);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
