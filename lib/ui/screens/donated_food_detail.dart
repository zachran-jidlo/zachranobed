import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class DonatedFoodDetail extends StatelessWidget {
  const DonatedFoodDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final offeredFood =
        ModalRoute.of(context)!.settings.arguments as OfferedFood;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetStyle.horizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    offeredFood.foodInfo.name,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ZachranObedTextField(
                label: ZOStrings.foodName,
                value: offeredFood.foodInfo.name,
                readOnly: true,
              ),
              _buildGap(),
              ZachranObedTextField(
                label: ZOStrings.allergens,
                value: offeredFood.foodInfo.allergens?.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZachranObedTextField(
                label: ZOStrings.numberOfServings,
                value: offeredFood.foodInfo.numberOfServings.toString(),
                readOnly: true,
              ),
              _buildGap(),
              ZachranObedTextField(
                label: ZOStrings.packaging,
                value: offeredFood.packaging,
                readOnly: true,
              ),
              _buildGap(),
              ZachranObedTextField(
                label: ZOStrings.consumeBy,
                value: DateFormat('dd.M.y HH:mm').format(offeredFood.consumeBy),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: 40.0);
  }
}
