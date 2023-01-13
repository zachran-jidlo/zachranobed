import 'package:flutter/material.dart';

class ZachranObedListTile extends StatelessWidget {
  const ZachranObedListTile({
    Key? key,
    required this.text,
    required this.onTapped,
  }) : super(key: key);

  final String text;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: ListTile(
        title: Text(text),
        onTap: onTapped,
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
