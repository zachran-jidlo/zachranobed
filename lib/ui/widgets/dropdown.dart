import 'package:flutter/material.dart';

class ZachranObedDropdown extends StatefulWidget {
  const ZachranObedDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    this.onValidation,
  }) : super(key: key);

  final String hintText;
  final List<String> items;
  final String? Function(String?)? onValidation;

  @override
  State<ZachranObedDropdown> createState() => _ZachranObedDropdownState();
}

class _ZachranObedDropdownState extends State<ZachranObedDropdown> {

  String _dropdownValue = "";

  final DropdownBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Colors.black,
    ),
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Text(widget.hintText),
      validator: widget.onValidation,
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _dropdownValue = value!;
        });
      },
      decoration: InputDecoration(
        enabledBorder: DropdownBorder,
        focusedBorder: DropdownBorder,
      ),
    );
  }
}
