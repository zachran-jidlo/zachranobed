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
    final date = boxMovement.date;
    final formattedDate = '${date.day.toString()}.${date.month.toString()}.';
    final countPrefix = boxMovement.count > 0 ? '+' : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: ZOColors.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(boxMovement.type.name),
        subtitle: Text(formattedDate),
        trailing: Text('$countPrefix${boxMovement.count} ks'),
        onTap: () => context.router.push(
          BoxMovementDetailRoute(boxMovement: boxMovement),
        ),
      ),
    );
  }
}
