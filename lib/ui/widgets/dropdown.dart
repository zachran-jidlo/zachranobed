import 'package:flutter/material.dart';

class ZachranObedDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? Function(String?)? onValidation;
  final Function(String) onChanged;

  const ZachranObedDropdown(
      {Key? key,
      required this.hintText,
      required this.items,
      this.onValidation,
      required this.onChanged})
      : super(key: key);

  @override
  State<ZachranObedDropdown> createState() => _ZachranObedDropdownState();
}

class _ZachranObedDropdownState extends State<ZachranObedDropdown> {
  final _dropdownBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.black),
    borderRadius: BorderRadius.zero,
  );

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
      decoration: InputDecoration(
        enabledBorder: _dropdownBorder,
        focusedBorder: _dropdownBorder,
      ),
    );
  }
}
