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
          horizontal: WidgetStyle.padding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    offeredFood.foodInfo.name,
                    style: const TextStyle(fontSize: FontSize.l),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ZOTextField(
                label: ZOStrings.foodName,
                value: offeredFood.foodInfo.name,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: ZOStrings.allergens,
                value: offeredFood.foodInfo.allergens?.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: ZOStrings.numberOfServings,
                value: offeredFood.foodInfo.numberOfServings.toString(),
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xl),
              const Row(
                children: [
                  Text(
                    ZOStrings.summaryInfo,
                    style: TextStyle(fontSize: FontSize.m),
                  ),
                ],
              ),
              _buildGap(),
              ZOTextField(
                label: ZOStrings.packaging,
                value: offeredFood.packaging,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: ZOStrings.consumeBy,
                value: DateFormat('dd.M.y HH:mm').format(offeredFood.consumeBy),
                readOnly: true,
              ),
              _buildGap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.l);
  }
}
