import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/models/offered_food.dart';

class DonatedFoodDetail extends StatelessWidget {
  const DonatedFoodDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offeredFood =
        ModalRoute.of(context)!.settings.arguments as OfferedFood;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail daru'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Název pokrmu: ${offeredFood.foodInfo.name}'),
            Text('Alergeny: ${offeredFood.foodInfo.allergens}'),
            Text('Počet porcí: ${offeredFood.foodInfo.numberOfServings}'),
            Text('Balení: ${offeredFood.packaging}'),
            Text(
                'Spotřebujte do: ${DateFormat('dd.MM.y HH:mm').format(offeredFood.consumeBy)}'),
            Text('Číslo týdne: ${offeredFood.weekNumber}'),
            Text('Dárce: ${offeredFood.donor}'),
          ],
        ),
      ),
    );
  }
}
