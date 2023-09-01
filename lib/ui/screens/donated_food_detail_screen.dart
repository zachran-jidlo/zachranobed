import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
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
                    offeredFood.dishName ?? '',
                    style: const TextStyle(fontSize: FontSize.l),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ZOTextField(
                label: context.l10n!.foodName,
                initialValue: offeredFood.dishName,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.allergens,
                initialValue: offeredFood.allergens?.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.numberOfServings,
                initialValue: offeredFood.numberOfServings.toString(),
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xl),
              Row(
                children: [
                  Text(
                    context.l10n!.summaryInfo,
                    style: const TextStyle(fontSize: FontSize.m),
                  ),
                ],
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.packaging,
                initialValue: offeredFood.packaging,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.consumeBy,
                initialValue:
                    DateFormat('dd.M.y HH:mm').format(offeredFood.consumeBy!),
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
