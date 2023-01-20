import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class DonatedFoodList extends StatefulWidget {
  const DonatedFoodList({Key? key}) : super(key: key);

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {

  // TODO - zatím natvrdo, pak tahat z databáze
  final List<OfferedFood> offeredFood = [
    OfferedFood(date: DateTime.now(), name: "Svíčková", allergens: "1, 2", numberOfServings: 7, packaging: 'Rekrabička', consumeBy: '22.01.2023 12:00'),
    OfferedFood(date: DateTime.now(), name: "Guláš", allergens: "1, 3, 5", numberOfServings: 5, packaging: 'Jednorázový obal', consumeBy: '22.01.2023 12:00'),
    OfferedFood(date: DateTime.now(), name: "Těstoviny", allergens: "1, 2", numberOfServings: 12, packaging: 'Jednorázový obal', consumeBy: '22.01.2023 12:00')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: offeredFood.length,
      itemBuilder: (context, index) {
        return DonatedFoodListTile(offeredFood: offeredFood[index]);
      },
    );
  }
}
