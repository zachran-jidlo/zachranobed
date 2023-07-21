import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';

class DonatedFoodListTile extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodListTile({
    super.key,
    required this.offeredFood,
  });

  @override
  Widget build(BuildContext context) {
    final String date =
        '${offeredFood.date.day.toString()}.${offeredFood.date.month.toString()}.';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: ZOColors.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(offeredFood.foodInfo.dishName),
        subtitle: Text(date),
        trailing: Text('${offeredFood.foodInfo.numberOfServings} ks'),
        onTap: () => Navigator.of(context)
            .pushNamed(RouteManager.donatedFoodDetail, arguments: offeredFood),
      ),
    );
  }
}
