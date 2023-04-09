import 'package:flutter/material.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class Donations extends StatelessWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(ZachranObedStrings.donationList),
        actions: [
          IconButton(
            onPressed: () {
              print('Kliknuto na hledat');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              DonatedFoodList(
                itemsLimit: 3,
                filter:
                    'cisloTydne(eq)${HelperService.getCurrentWeekNumber},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                title: 'Tento týden',
                showServingsSum: true,
              ),
              const SizedBox(height: 30),
              DonatedFoodList(
                itemsLimit: 3,
                filter:
                    'cisloTydne(eq)${HelperService.getCurrentWeekNumber - 1},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                title: 'Minulý týden',
                showServingsSum: true,
              ),
              const SizedBox(height: 85),
            ],
          ),
        ),
      ),
      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
