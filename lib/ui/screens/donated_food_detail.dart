import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';

class DonatedFoodDetail extends StatelessWidget {
  const DonatedFoodDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final offeredFood = ModalRoute.of(context)!.settings.arguments as OfferedFood;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Detail daru"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Název pokrmu: ${offeredFood.name}"),
            Text("Alergeny: ${offeredFood.allergens}"),
            Text("Počet porcí: ${offeredFood.numberOfServings}"),
            Text("Balení: ${offeredFood.packaging}"),
            Text("Spotřebujte do: ${offeredFood.consumeBy}"),
          ],
        ),
      ),
    );
  }
}
