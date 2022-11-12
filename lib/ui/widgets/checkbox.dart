import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';

class ZachranObedCheckbox extends StatelessWidget {
  const ZachranObedCheckbox({
    Key? key,
    required this.text,
    this.isChecked = false,
    required this.whatIsChecked,
  }) : super(key: key);

  final String text;
  final bool isChecked;
  final ValueChanged<bool> whatIsChecked;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(text),
      activeColor: ZachranObedColors.primaryLight,
      value: isChecked,
      onChanged: (bool? value) {
        whatIsChecked(value!);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
