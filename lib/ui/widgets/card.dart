import 'package:flutter/material.dart';

class ZachranObedCard extends StatefulWidget {
  const ZachranObedCard({
    Key? key,
    required this.text,
    required this.measuredVariableText,
    required this.buttonText,
    required this.onPressed
  }) : super(key: key);

  final String text;
  final String measuredVariableText;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  State<ZachranObedCard> createState() => _ZachranObedCardState();
}

class _ZachranObedCardState extends State<ZachranObedCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: Colors.black,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.text),
                Text(
                  widget.measuredVariableText,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: widget.onPressed,
              child: Text(widget.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
