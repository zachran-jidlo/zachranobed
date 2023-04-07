import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes.dart';

class DonatedFoodListTile extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodListTile({
    Key? key,
    required this.offeredFood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String date =
        '${offeredFood.date.day.toString().padLeft(2, '0')}.${offeredFood.date.month.toString().padLeft(2, '0')}.';

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: ListTile(
        title: Text('$date ${offeredFood.foodInfo.name}'),
        trailing: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(text: '${offeredFood.foodInfo.numberOfServings} ks'),
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
        onTap: () => Navigator.of(context)
            .pushNamed(RouteManager.donatedFoodDetail, arguments: offeredFood),
      ),
    );
  }
}
