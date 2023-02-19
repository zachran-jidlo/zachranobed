import 'package:flutter/material.dart';

class ZachranObedCard extends StatefulWidget {

  final String text;
  final String measuredVariableText;
  final String buttonText;
  final VoidCallback onPressed;

  const ZachranObedCard({
    Key? key,
    required this.text,
    required this.measuredVariableText,
    required this.buttonText,
    required this.onPressed
  }) : super(key: key);

  @override
  State<ZachranObedCard> createState() => _ZachranObedCardState();
}

class _ZachranObedCardState extends State<ZachranObedCard> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.text),
                  Text(
                    widget.measuredVariableText,
                    style: const TextStyle(
                      fontSize: 32,
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
      ),
    );
  }
}
