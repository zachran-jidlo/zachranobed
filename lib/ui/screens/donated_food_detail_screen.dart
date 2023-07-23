import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class DonatedFoodDetailScreen extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodDetailScreen({super.key, required this.offeredFood});

  @override
  Widget build(BuildContext context) {
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
                    offeredFood.foodInfo.dishName,
                    style: const TextStyle(fontSize: FontSize.l),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ZOTextField(
                label: AppLocalizations.of(context)!.foodName,
                value: offeredFood.foodInfo.dishName,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: AppLocalizations.of(context)!.allergens,
                value: offeredFood.foodInfo.allergens?.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: AppLocalizations.of(context)!.numberOfServings,
                value: offeredFood.foodInfo.numberOfServings.toString(),
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xl),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.summaryInfo,
                    style: const TextStyle(fontSize: FontSize.m),
                  ),
                ],
              ),
              _buildGap(),
              ZOTextField(
                label: AppLocalizations.of(context)!.packaging,
                value: offeredFood.packaging,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: AppLocalizations.of(context)!.consumeBy,
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
