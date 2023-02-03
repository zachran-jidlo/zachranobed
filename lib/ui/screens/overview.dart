import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/helpers/current_user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

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
                  children: const <Widget>[
                    DonationCountdownTimer(),
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
              child: DonatedFoodList(
                itemsLimit: 3,
                filter: 'darce.id(eq)${getCurrentUser(context).internalId}',
                title: ZachranObedStrings.lastDonated,
              ),
            ),
            const SizedBox(height: 85),
          ],
        ),
      ),

      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () => Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
