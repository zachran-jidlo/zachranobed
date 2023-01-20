import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/custom_icons.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class Donations extends StatefulWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    "Tento týden",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '000 ks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              for (int i = 0; i < 3; i++)
                DonatedFoodListTile(
                  text: '31.12. Název pokrmu',
                  numberOfServings: 5,
                  onTapped: () {
                    print("Kliknuto na darovaný pokrm");
                  },
                ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    "Minulý týden",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '000 ks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              for (int i = 0; i < 3; i++)
                DonatedFoodListTile(
                  text: '31.12. Název pokrmu',
                  numberOfServings: 5,
                  onTapped: () {
                    print("Kliknuto na darovaný pokrm");
                  },
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
