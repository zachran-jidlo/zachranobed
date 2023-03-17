import 'package:flutter/material.dart';
import 'package:zachranobed/helpers/current_user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/shared/constants.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getCurrentUser(context)!.email),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(RouteManager.login),
            child: const Text(
              ZachranObedStrings.logout,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Menu', style: TextStyle(fontSize: 32)),
      ),
    );
  }
}
