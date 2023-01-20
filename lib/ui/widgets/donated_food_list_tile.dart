import 'package:flutter/material.dart';

class DonatedFoodListTile extends StatelessWidget {
  const DonatedFoodListTile({
    Key? key,
    required this.text,
    required this.onTapped,
    required this.numberOfServings,
  }) : super(key: key);

  final String text;
  final VoidCallback onTapped;
  final int numberOfServings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: ListTile(
        title: Text(text),
        trailing: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: "$numberOfServings ks",
              ),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
        onTap: onTapped,
      ),
    );
  }
}
