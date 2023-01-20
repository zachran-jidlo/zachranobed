import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/routes.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<User>(
          builder: (context, user, child) {
            return Text(user.email);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(RouteManager.login),
            child: const Text(
              ZachranObedStrings.logout,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Menu',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
