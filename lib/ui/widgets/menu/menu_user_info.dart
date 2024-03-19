import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/models/user_data.dart';

class MenuUserInfo extends StatelessWidget {
  final UserData user;

  const MenuUserInfo({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZOColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetStyle.padding,
          vertical: GapSize.xxs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              user.establishmentName,
              style: const TextStyle(
                fontSize: FontSize.s,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: FontSize.xs,
                color: ZOColors.onPrimaryLight
              ),
            ),
          ],
        ),
      ),
    );
  }
}
