import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/ui/model/food_allergen.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/persistent_snackbar.dart';
import 'package:zachranobed/ui/widgets/supporting_text.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class DonatedFoodDetailScreen extends StatelessWidget {
  final OfferedFood offeredFood;

  const DonatedFoodDetailScreen({super.key, required this.offeredFood});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: ZOAppBar(
        title: offeredFood.dishName,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Column(
            children: <Widget>[
              _buildAllergens(context),
              _buildGap(),
              ZOTextField(
                label: context.l10n!.foodCategory,
                initialValue: _getFoodCategoryFromType(context) ?? offeredFood.foodCategory,
                readOnly: true,
              ),
              _buildGap(),
              if (offeredFood.foodTemperature != null) ...[
                ZOTextField(
                  label: context.l10n!.foodTemperatureWithCelsius,
                  initialValue: offeredFood.foodTemperature?.toString(),
                  readOnly: true,
                ),
                _buildGap(),
              ],
              if (offeredFood.numberOfPackages != null) ...[
                ZOTextField(
                  label: context.l10n!.numberOfPackages,
                  initialValue: offeredFood.numberOfPackages.toString(),
                  readOnly: true,
                ),
                _buildGap(),
              ],
              if (offeredFood.numberOfServings != null) ...[
                ZOTextField(
                  label: context.l10n!.numberOfServings,
                  initialValue: offeredFood.numberOfServings.toString(),
                  readOnly: true,
                ),
                _buildGap(),
              ],
              if (offeredFood.preparedAt != null) ...[
                ZOTextField(
                  label: context.l10n!.preparedAt,
                  initialValue: _formatFoodDateTime(
                    date: offeredFood.preparedAt!,
                    dateOnPackaging: context.l10n!.preparedAtOnPackaging,
                    withTime: false,
                  ),
                  readOnly: true,
                ),
                _buildGap(),
              ],
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
                    ' ${DateFormat('d.M.y').format(offeredFood.date)}.',
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

  Widget _buildAllergens(BuildContext context) {
    // Return only text widget if there are no allergens
    if (listEquals(offeredFood.allergens, [FoodAllergen.noAllergensNumber])) {
      return ZOTextField(
        label: context.l10n!.allergens,
        initialValue: context.l10n!.allergensNotPresent,
        readOnly: true,
      );
    }

    // Return only text widget if there are allergens on packaging
    if (listEquals(offeredFood.allergens, [FoodAllergen.onPackageNumber])) {
      return ZOTextField(
        label: context.l10n!.allergens,
        initialValue: context.l10n!.allergensListedOnPackage,
        readOnly: true,
      );
    }

    return Row(
      children: [
        Expanded(
          child: ZOTextField(
            label: context.l10n!.allergens,
            initialValue: offeredFood.allergens.join(", "),
            readOnly: true,
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAllergens(context, offeredFood.allergens),
          color: ZOColors.primary,
        )
      ],
    );
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

  /// Gets the food category name from the offered food's type to keep it up-to-date with application strings.
  String? _getFoodCategoryFromType(BuildContext context) {
    if (offeredFood.foodCategoryType == null) {
      return null;
    }
    final categories = FoodCategory.createValues(context);
    final category = categories.firstWhereOrNull((category) => category.type == offeredFood.foodCategoryType);
    return category?.name;
  }

  void _showAllergens(BuildContext context, List<String> allergens) {
    final allergenNumbers = offeredFood.allergens.map((it) => int.parse(it));
    final allergens = FoodAllergen.all(context).where((it) => allergenNumbers.contains(it.number));
    FoodAllergensBottomSheet.show(context, allergens.toList());
  }
}
