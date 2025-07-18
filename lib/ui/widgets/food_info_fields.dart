import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/enums/food_form_field_type.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/model/food_allergen.dart';
import 'package:zachranobed/ui/widgets/counter_field.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/ui/widgets/food_allergens_chips.dart';
import 'package:zachranobed/ui/widgets/food_date_time_chips.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/section_header.dart';
import 'package:zachranobed/ui/widgets/single_select_chips.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodInfoFields extends StatefulWidget {
  final FoodInfo foodInfo;
  final Function(FoodInfo) onChanged;

  final FormValidationManager formValidationManager;

  const FoodInfoFields({
    super.key,
    required this.foodInfo,
    required this.onChanged,
    required this.formValidationManager,
  });

  @override
  State<FoodInfoFields> createState() => _FoodInfoFieldsState();
}

class _FoodInfoFieldsState extends State<FoodInfoFields> {

  @override
  Widget build(BuildContext context) {
    const index = 0;
    final foodType = widget.foodInfo.foodCategory?.type;
    return Column(
      children: [
        ..._buildFoodNamePart(index),
        _buildGap(),
        ..._buildFoodAllergensPart(index),
        _buildGap(),
        ..._buildFoodCategoryPart(index),
        _buildGap(),
        if (foodType == FoodCategoryType.warm) ...[
          ..._buildTemperaturePart(index),
          _buildGap(),
        ],
        if (foodType == FoodCategoryType.packaged) ...[
          ..._buildNumberOfPackages(index),
          _buildGap(),
        ],
        if (foodType != FoodCategoryType.packaged) ...[
          ..._buildNumberOfServingsPart(index),
          _buildGap(),
        ],
        if (foodType == FoodCategoryType.cooled) ...[
          ..._buildPreparedAtPart(index),
          _buildGap(),
        ],
        ..._buildConsumeByPart(index),
        _buildGap(),
      ],
    );
  }

  List<Widget> _buildFoodNamePart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.foodName);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      ZOTextField(
        key: ValueKey(formFieldKey),
        label: context.l10n!.foodName,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodNameValidator(context),
        ),
        onChanged: (val) {
          widget.onChanged(widget.foodInfo.copyWith(dishName: val));
        },
        initialValue: widget.foodInfo.dishName,
      )
    ];
  }

  List<Widget> _buildFoodAllergensPart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.allergens);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.allergens,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        action: SectionHeaderIcon(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            final allergens = FoodAllergen.all(context);
            FoodAllergensBottomSheet.show(context, allergens, fullHeight: true);
          },
        ),
      ),
      const SizedBox(height: GapSize.xs),
      FoodAllergensChips(
        key: ValueKey(formFieldKey),
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        selection: widget.foodInfo.allergens ?? [],
        onSelectionChanged: (allergens) {
          widget.onChanged(widget.foodInfo.copyWith(allergens: allergens));
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodAllergensValidator(context),
        ),
      ),
    ];
  }

  List<Widget> _buildFoodCategoryPart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.foodCategory);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodCategory,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      SingleSelectChips(
        key: ValueKey(formFieldKey),
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodCategory.createValues(context),
        selection: widget.foodInfo.foodCategory,
        optionLabel: (e) => e.name,
        onSelectionChanged: (value) {
          widget.onChanged(widget.foodInfo.copyWithFoodCategory(value));
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodCategoryValidator(context),
        ),
      )
    ];
  }

  List<Widget> _buildTemperaturePart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.temperature);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodTemperature,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      CounterField(
        key: ValueKey(formFieldKey),
        label: context.l10n!.foodTemperatureWithCelsius,
        minValue: Constants.foodTemperatureMin,
        maxValue: Constants.foodTemperatureMax,
        noValueFallback: Constants.foodTemperatureInitial,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodTemperatureValidator(context),
        ),
        initialValue: widget.foodInfo.foodTemperature ?? Constants.foodTemperatureInitial,
        onChanged: (val) {
          widget.onChanged(widget.foodInfo.copyWith(foodTemperature: val));
        },
      ),
    ];
  }

  List<Widget> _buildNumberOfServingsPart(int index) {
    final keyServings = _createFormFieldKey(FormFieldType.numberOfServings);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.numberOfServings,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      CounterField(
        key: ValueKey(keyServings),
        label: context.l10n!.numberOfServings,
        focusNode: widget.formValidationManager.getFocusNode(keyServings),
        onValidation: widget.formValidationManager.wrapValidator(
          keyServings,
          FieldValidationUtils.getServingsValidator(context),
        ),
        initialValue: widget.foodInfo.numberOfServings ?? 0,
        onChanged: (val) {
          widget.onChanged(widget.foodInfo.copyWith(numberOfServings: val));
        },
      ),
    ];
  }

  List<Widget> _buildNumberOfPackages(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.numberOfPackages);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.numberOfPackages,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      CounterField(
        key: ValueKey(formFieldKey),
        label: context.l10n!.numberOfPackages,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getPackagesValidator(context),
        ),
        initialValue: widget.foodInfo.numberOfPackages ?? 0,
        onChanged: (val) {
          widget.onChanged(widget.foodInfo.copyWith(numberOfPackages: val));
        },
      ),
    ];
  }

  List<Widget> _buildPreparedAtPart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.preparedAt);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.preparedAt,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      FoodDateTimeChips(
        key: ValueKey(formFieldKey),
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodDateTimeOption.createPastOptions(context),
        selection: widget.foodInfo.preparedAt,
        onSelectionChanged: (value) {
          widget.onChanged(widget.foodInfo.copyWith(preparedAt: value));
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getPreparedAtValidator(context),
        ),
        formatSelectedDate: (e) => null,
        hasTime: false,
      ),
    ];
  }

  List<Widget> _buildConsumeByPart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.consumeBy);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.consumeBy,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        action: SectionHeaderIcon(
          icon: const Icon(Icons.today_rounded),
          onPressed: () async {
            final now = DateTime.now();
            final date = await DateTimePicker.pickDateTime(
              context: context,
              initial: widget.foodInfo.consumeBy?.getDate() ?? _consumeByInitialTime(),
              minimum: now,
            );

            if (date != null) {
              final consumeBy = FoodDateTimeSpecified(date: date);
              widget.onChanged(widget.foodInfo.copyWith(consumeBy: consumeBy));
            }
          },
        ),
      ),
      const SizedBox(height: GapSize.xs),
      FoodDateTimeChips(
        // Use a compound key, so that state is correctly updated when value set
        // from [DateTimePicker.pickDateTime] above
        key: ValueKey("$formFieldKey-${widget.foodInfo.consumeBy.hashCode}"),
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodDateTimeOption.createFutureOptions(context),
        selection: widget.foodInfo.consumeBy,
        onSelectionChanged: (value) {
          widget.onChanged(widget.foodInfo.copyWith(consumeBy: value));
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getConsumeByValidator(context),
        ),
        formatSelectedDate: context.l10n!.consumeByTemplate,
        initialTime: _consumeByInitialTime,
      ),
    ];
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.xl);
  }

  DateTime _consumeByInitialTime() {
    const offset = Duration(minutes: Constants.foodConsumeByMinutesOffset);
    return DateTime.now().add(offset);
  }

  String _createFormFieldKey(FormFieldType type) {
    return "food${widget.foodInfo.id}-field${type.name.toUpperCase()}";
  }
}
