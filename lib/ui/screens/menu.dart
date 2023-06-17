import 'package:flutter/material.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/ui/widgets/menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(HelperService.getCurrentUser(context)!.email),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Organizace', style: TextStyle(fontSize: 16.0)),
              ],
            ),
            MenuItem(
              leadingIcon: Icons.business,
              text: user.organization,
              isClickable: false,
            ),
          ],
        ),
      ),
    );
  }
}
