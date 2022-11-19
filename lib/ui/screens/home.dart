import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/roots.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<User>(context, listen: false).newUser('', '');
              Navigator.of(context).pushReplacementNamed(RouteManager.login);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Consumer<User>(
          builder: (context, user, child) {
            return Text('Ahoj ${user.email}');
          },
        ),
      ),
    );
  }
}
