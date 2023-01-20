import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

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
              Navigator.of(context).pushReplacementNamed(RouteManager.login);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                children: <Widget>[
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
              child: Row(
                children: const <Widget>[
                  Text(
                    ZachranObedStrings.lastDonated,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: DonatedFoodList(),
            ),
          ],
        ),
      ),

      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () => Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
