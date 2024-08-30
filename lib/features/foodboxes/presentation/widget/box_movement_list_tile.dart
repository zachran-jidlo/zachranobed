import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/routes/app_router.gr.dart';

class BoxMovementListTile extends StatelessWidget {
  final BoxMovement boxMovement;

  const BoxMovementListTile({
    super.key,
    required this.boxMovement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = boxMovement.date;
    final formattedDate = '${date.day.toString()}.${date.month.toString()}.';
    final countPrefix = boxMovement.count > 0 ? '+' : '';
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
            boxMovement.type.name,
            style: textTheme.bodyLarge,
          ),
          subtitle: Text(
            formattedDate,
            style: textTheme.bodySmall?.copyWith(
              color: ZOColors.onPrimaryLight,
            ),
          ),
          trailing: Text(
            '$countPrefix${boxMovement.count} ks',
            style: textTheme.labelLarge?.copyWith(
              color: ZOColors.onPrimaryLight,
            ),
          ),
          onTap: () => context.router.push(
            BoxMovementDetailRoute(boxMovement: boxMovement),
          ),
        ),
      ),
    );
  }
}
