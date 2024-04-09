import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZODateTimePicker extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? onValidation;
  final IconData icon;
  final Function(DateTime?) onDateTimePicked;
  final DateTime? minimumDate;

  const ZODateTimePicker({
    super.key,
    required this.label,
    required this.controller,
    this.onValidation,
    required this.icon,
    required this.onDateTimePicked,
    this.minimumDate,
  });

  @override
  State<ZODateTimePicker> createState() => _ZODateTimePickerState();
}

class _ZODateTimePickerState extends State<ZODateTimePicker> {
  DateTime _dateTime = DateTime.now();

  Future<DateTime?> _pickDate() => showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: widget.minimumDate ?? DateTime(DateTime.now().year),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> _pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

  Future<DateTime?> _pickDateTime() async {
    DateTime? date = await _pickDate();
    if (date == null) return null;

    TimeOfDay? time = await _pickTime();
    if (time == null) return null;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _dateTime = dateTime;
      widget.controller.text =
          '${_dateTime.day}.${_dateTime.month}.${_dateTime.year} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}';
    });

    return dateTime;
  }

  final _dateTimePickerErrorBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xffd32f2f)),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await _pickDateTime();
        widget.onDateTimePicked(date);
      },
      child: TextFormField(
        controller: widget.controller,
        validator: widget.onValidation,
        enabled: false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          disabledBorder: WidgetStyle.inputBorder,
          errorBorder: _dateTimePickerErrorBorder,
          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
          suffixIcon: Icon(widget.icon),
          suffixIconColor: Colors.black,
        ),
      ),
    );
  }
}
