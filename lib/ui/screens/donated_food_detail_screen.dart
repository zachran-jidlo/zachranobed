import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/shared/constants.dart';
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
                  Text(
                    offeredFood.dishName ?? '',
                    style: const TextStyle(fontSize: FontSize.l),
                  ),
                ],
              ),
              const SizedBox(height: GapSize.s),
              ZOTextField(
                label: context.l10n!.allergens,
                initialValue: offeredFood.allergens?.join(", "),
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.foodCategory,
                initialValue: offeredFood.foodCategory,
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
                label: context.l10n!.boxType,
                initialValue: offeredFood.boxType,
                readOnly: true,
              ),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.consumeBy,
                initialValue:
                    DateFormat('d.M.y HH:mm').format(offeredFood.consumeBy!),
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xs),
              SupportingText(
                text: '${context.l10n!.donatedOn}'
                    ' ${DateFormat('d.M.y').format(offeredFood.date!)}'
                    ' ${context.l10n!.atTime}'
                    ' ${DateFormat('HH:mm').format(offeredFood.date!)}.',
              ),
              const SizedBox(height: GapSize.xs),
              ZOPersistentSnackBar(message: context.l10n!.formCantBeEdited),
              const SizedBox(height: GapSize.s),
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
