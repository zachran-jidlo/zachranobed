import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
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
            icon: const Icon(MaterialSymbols.mail),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouteManager.login);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          MultiSliver(
            children: [
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
                        print('Jdu na statistiky');
                      },
                    ),
                    ZachranObedCard(
                      text: ZachranObedStrings.borrowedBoxes,
                      measuredVariableText: '32/100',
                      buttonText: ZachranObedStrings.change,
                      onPressed: () {
                        print('Jdu změnit počet krabiček');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                sliver: DonatedFoodList(
                  itemsLimit: 5,
                  filter:
                      'darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: ZachranObedStrings.lastDonated,
                ),
              ),
              const SizedBox(height: 85),
            ],
          ),
        ],
      ),
      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
