import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/list_tile.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZachranObedStrings.overview),
        actions: [
          IconButton(
            onPressed: () {
              print('Bell pressed');
            },
            icon: const Icon(Icons.add_alert),
          ),
          IconButton(
            onPressed: () {
              Provider.of<User>(context, listen: false).newUser('', '');
              Navigator.of(context).pushReplacementNamed(RouteManager.login);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
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
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(ZachranObedStrings.lastDonated),
            ),
          ),
          // TODO - tohle je zatím natvrdo, pak v nějakém cyklu procházet x posledních darovaných pokrmů
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ZachranObedListTile(
              text: '31.12. Název pokrmu 00 ks',
              onTapped: () {
                print("Kliknuto na darovaný pokrm");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ZachranObedListTile(
              text: '31.12. Název pokrmu 00 ks',
              onTapped: () {
                print("Kliknuto na darovaný pokrm");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ZachranObedListTile(
              text: '31.12. Název pokrmu 00 ks',
              onTapped: () {
                print("Kliknuto na darovaný pokrm");
              },
            ),
          ),

          const SizedBox(height: 50),
          Consumer<User>(
            builder: (context, user, child) {
              return Text('Ahoj ${user.email}');
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteManager.offerFood);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
