import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? Function(String?)? onValidation;
  final Function(String) onChanged;

  const ZachranObedDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onValidation,
    required this.onChanged,
  });

  @override
  State<ZachranObedDropdown> createState() => _ZachranObedDropdownState();
}

class _ZachranObedDropdownState extends State<ZachranObedDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Text(widget.hintText),
      validator: widget.onValidation,
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          widget.onChanged(value!);
        });
      },
      decoration: const InputDecoration(
        enabledBorder: WidgetStyle.inputBorder,
        focusedBorder: WidgetStyle.inputBorder,
      ),
    );
  }
}
