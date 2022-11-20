import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/custom_icons_icons.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/card.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ZachranObedStrings.overview),
        actions: [
          IconButton(
            onPressed: () {
              print('Bell pressed');
            },
            icon: Icon(Icons.add_alert),
          ),
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
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dnes můžete darovat ještě 23 h : 59 min',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  ZachranObedCard(
                    text: ZachranObedStrings.savedLunches,
                    measuredVariableText: '672',
                    buttonText: ZachranObedStrings.statistics,
                    onPressed: () {
                      print("Jdu na statistiky");
                    },
                  ),
                  ZachranObedCard(
                      text: ZachranObedStrings.borrowedBoxes,
                      measuredVariableText: '32/100',
                      buttonText: ZachranObedStrings.change,
                      onPressed: () {
                        print("Jdu změnit počet krabiček");
                      },
                  ),
                ],
              ),
            ),

            Consumer<User>(
              builder: (context, user, child) {
                return Text('Ahoj ${user.email}');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ZachranObedStrings.overview,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: ZachranObedStrings.donations,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.graph),
            label: ZachranObedStrings.statistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: ZachranObedStrings.menu,
          ),
        ],
      ),
    );
  }
}
