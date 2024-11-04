import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/ui/widgets/snackbar/persistent_snackbar.dart';
import 'package:zachranobed/ui/widgets/supporting_text.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class DonatedFoodDetailScreen extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodDetailScreen({super.key, required this.offeredFood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      offeredFood.dishName,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: FontSize.l),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GapSize.m),
              ZOTextField(
                label: context.l10n!.allergens,
                initialValue: offeredFood.allergens.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.foodCategory,
                initialValue: offeredFood.foodCategory,
                readOnly: true,
              ),
              _buildGap(),
              if (offeredFood.foodTemperature != null)
                ZOTextField(
                  label: context.l10n!.foodTemperatureWithCelsius,
                  initialValue: offeredFood.foodTemperature?.toString(),
                  readOnly: true,
                ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.numberOfServings,
                initialValue: offeredFood.numberOfServings.toString(),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.numberOfBoxes,
                initialValue: offeredFood.numberOfBoxes.toString(),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.boxType,
                initialValue: offeredFood.boxType,
                readOnly: true,
              ),
              if (offeredFood.preparedAt != null)
                Column(
                  children: [
                    _buildGap(),
                    ZOTextField(
                      label: context.l10n!.preparedAt,
                      initialValue: _formatFoodDateTime(
                        date: offeredFood.preparedAt!,
                        dateOnPackaging: context.l10n!.preparedAtOnPackaging,
                        withTime: false,
                      ),
                      readOnly: true,
                    ),
                  ],
                ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.consumeBy,
                initialValue: _formatFoodDateTime(
                  date: offeredFood.consumeBy,
                  dateOnPackaging: context.l10n!.consumeByOnPackaging,
                  withTime: true,
                ),
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xs),
              SupportingText(
                text: '${context.l10n!.donatedOn}'
                    ' ${DateFormat('d.M.y').format(offeredFood.date)}'
                    ' ${context.l10n!.atTime}'
                    ' ${DateFormat('HH:mm').format(offeredFood.date)}.',
              ),
              const SizedBox(height: GapSize.xs),
              ZOPersistentSnackBar(message: context.l10n!.formCantBeEdited),
              const SizedBox(height: GapSize.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.m);
  }

  String _formatFoodDateTime({
    required FoodDateTime date,
    required String dateOnPackaging,
    required bool withTime,
  }) {
    switch (date) {
      case FoodDateTimeSpecified():
        final format = withTime ? "d.M.y HH:mm" : "d.M.y";
        return DateFormat(format).format(date.date);
      case FoodDateTimeOnPackaging():
        return dateOnPackaging;
    }
  }
}
