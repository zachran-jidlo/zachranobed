import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/custom_icons.dart';
import 'package:zachranobed/routes.dart';
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
              print('Kliknuto na "hledat"');
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
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(CustomIcons.filter, size: 15.0,),
                    label: const Text(ZachranObedStrings.filter),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      print("Kliknuto na filtrovat");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const DonatedFoodList(
                itemsLimit: 3,
                title: 'Tento týden',
                showServingsSum: true,
              ),
              const SizedBox(height: 30),

              const DonatedFoodList(
                itemsLimit: 3,
                title: 'Minulý týden',
                showServingsSum: true,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      floatingActionButton: ZachranObedFloatingButton(
          onPressed: () => Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
