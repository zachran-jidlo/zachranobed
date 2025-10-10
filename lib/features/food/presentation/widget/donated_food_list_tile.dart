import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';

class DonatedFoodListTile extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodListTile({super.key, required this.offeredFood});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String date = '${offeredFood.date.day.toString()}.${offeredFood.date.month.toString()}.';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ZOColors.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            offeredFood.dishName,
            style: textTheme.bodyLarge,
          ),
          subtitle: Text(
            date,
            style: textTheme.bodySmall?.copyWith(
              color: ZOColors.onPrimaryLight,
            ),
          ),
          trailing: Text(
            '${offeredFood.numberOfServings ?? offeredFood.numberOfPackages} ks',
            style: textTheme.labelLarge?.copyWith(
              color: ZOColors.onPrimaryLight,
            ),
          ),
          onTap: () => context.router.push(DonatedFoodDetailRoute(offeredFood: offeredFood)),
        ),
      ),
    );
  }
}
