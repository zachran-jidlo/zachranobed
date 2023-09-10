import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/models/box_movement.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/shared/constants.dart';

class BoxMovementListTile extends StatelessWidget {
  final BoxMovement boxMovement;
  final UserData user;

  const BoxMovementListTile({
    super.key,
    required this.boxMovement,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final String date =
        '${boxMovement.date?.day.toString()}.${boxMovement.date?.month.toString()}.';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: ZOColors.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(boxMovement.boxType!),
        subtitle: Text(date),
        trailing: user.establishmentId == boxMovement.senderId
            ? Text('-${boxMovement.numberOfBoxes} ks')
            : Text('+${boxMovement.numberOfBoxes} ks'),
        onTap: () => context.router.push(
          BoxMovementDetailRoute(boxMovement: boxMovement, user: user),
        ),
      ),
    );
  }
}
