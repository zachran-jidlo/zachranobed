import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/enums/food_form_field_type.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_date_time.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/counter_field.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/ui/widgets/food_allergens_chips.dart';
import 'package:zachranobed/ui/widgets/food_date_time_chips.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/remove_section_button.dart';
import 'package:zachranobed/ui/widgets/section_header.dart';
import 'package:zachranobed/ui/widgets/single_select_chips.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodSectionFields extends StatefulWidget {
  final FormValidationManager formValidationManager;
  final List<FoodInfo> foodSections;
  final List<bool> checkboxValues;
  final List<FoodBoxType> boxTypes;

  const FoodSectionFields({
    super.key,
    required this.formValidationManager,
    required this.foodSections,
    required this.checkboxValues,
    required this.boxTypes,
  });

  @override
  State<FoodSectionFields> createState() => _FoodSectionFieldsState();
}

class _FoodSectionFieldsState extends State<FoodSectionFields> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.foodSections.length,
      itemBuilder: (context, index) {
        return _buildFoodSection(
          widget.foodSections[index],
          index,
        );
      },
    );
  }

  Widget _buildTextField({
    required int index,
    required FormFieldType type,
    required final String label,
    required final String? Function(String?) onValidation,
    final TextInputType? inputType,
    final List<TextInputFormatter>? textInputFormatters,
    final Function(String)? onChanged,
    final String? initialValue,
    final String? supportingText,
  }) {
    final formFieldKey = type.createFormFieldKey(index);
    return ZOTextField(
      label: label,
      focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
      onValidation: widget.formValidationManager.wrapValidator(
        formFieldKey,
        onValidation,
      ),
      inputType: inputType,
      textInputFormatters: textInputFormatters,
      onChanged: onChanged,
      initialValue: initialValue,
      supportingText: supportingText,
    );
  }

  List<Widget> _buildFoodNamePart(int index) {
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      _buildTextField(
        index: index,
        type: FormFieldType.foodName,
        label: context.l10n!.foodName,
        onValidation: FieldValidationUtils.getFoodNameValidator(context),
        onChanged: (val) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(dishName: val);
        },
        initialValue: widget.foodSections[index].dishName,
      ),
    ];
  }

  List<Widget> _buildFoodAllergensPart(int index) {
    final formFieldKey = FormFieldType.allergens.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.allergens,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actionIcon: const Icon(Icons.info_outline),
        onActionPressed: () => FoodAllergensBottomSheet.show(context),
      ),
      const SizedBox(height: GapSize.xs),
      FoodAllergensChips(
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        selection: widget.foodSections[index].allergens ?? [],
        onSelectionChanged: (allergens) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(allergens: allergens);
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodAllergensValidator(context),
        ),
      ),
    ];
  }

  List<Widget> _buildFoodCategoryPart(int index) {
    final formFieldKey = FormFieldType.foodCategory.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodCategory,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      SingleSelectChips(
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodCategory.createValues(context),
        selection: widget.foodSections[index].foodCategory,
        optionLabel: (e) => e.name,
        onSelectionChanged: (value) {
          setState(() {
            widget.foodSections[index] =
                widget.foodSections[index].copyWithFoodCategory(value);
          });
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodCategoryValidator(context),
        ),
      )
    ];
  }

  List<Widget> _buildTemperaturePart(int index) {
    final formFieldKey = FormFieldType.temperature.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.foodTemperature,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      CounterField(
        label: context.l10n!.foodTemperatureWithCelsius,
        minValue: Constants.foodTemperatureMin,
        maxValue: Constants.foodTemperatureMax,
        noValueFallback: Constants.foodTemperatureInitial,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodTemperatureValidator(context),
        ),
        initialValue: widget.foodSections[index].foodTemperature ??
            Constants.foodTemperatureInitial,
        onChanged: (val) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(foodTemperature: val);
        },
      ),
    ];
  }

  List<Widget> _buildBoxTypesPart(int index) {
    final formFieldKey = FormFieldType.boxType.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.boxType,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      SingleSelectChips<FoodBoxType>(
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: widget.boxTypes,
        selection: widget.foodSections[index].foodBoxType,
        optionLabel: (e) => e.name,
        onSelectionChanged: (value) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(foodBoxType: value);
        },
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getBoxTypeValidator(context),
        ),
      )
    ];
  }

  List<Widget> _buildNumberOfServingsPart(int index) {
    return [
      SectionHeader(
        title: Text(
          context.l10n!.boxType,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      CounterField(
        label: context.l10n!.numberOfServings,
        focusNode: widget.formValidationManager.getFocusNode(
          FormFieldType.numberOfServings.createFormFieldKey(index),
        ),
        onValidation: widget.formValidationManager.wrapValidator(
          FormFieldType.numberOfServings.createFormFieldKey(index),
          FieldValidationUtils.getServingsValidator(context),
        ),
        initialValue: widget.foodSections[index].numberOfServings ?? 0,
        onChanged: (val) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(numberOfServings: val);
        },
      ),
      _buildGap(),
      ZOCheckbox.plain(
        isChecked: widget.checkboxValues[index],
        onChanged: (bool? value) {
          setState(() {
            widget.checkboxValues[index] = value!;
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(numberOfBoxes: null);
          });
        },
        title: context.l10n!.sameNumberOfServingsAsBoxes,
      ),
      if (!widget.checkboxValues[index])
        Column(
          children: [
            _buildGap(),
            CounterField(
              label: context.l10n!.numberOfBoxes,
              focusNode: widget.formValidationManager.getFocusNode(
                FormFieldType.numberOfBoxes.createFormFieldKey(index),
              ),
              onValidation: widget.formValidationManager.wrapValidator(
                FormFieldType.numberOfBoxes.createFormFieldKey(index),
                FieldValidationUtils.getBoxNumberValidator(context),
              ),
              initialValue: widget.foodSections[index].numberOfBoxes ?? 0,
              onChanged: (val) {
                widget.foodSections[index] =
                    widget.foodSections[index].copyWith(numberOfBoxes: val);
              },
            ),
          ],
        )
    ];
  }

  List<Widget> _buildPreparedAtPart(int index) {
    final formFieldKey = FormFieldType.preparedAt.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.preparedAt,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(height: GapSize.xs),
      FoodDateTimeChips(
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodDateTimeOption.createPastOptions(context),
        selection: widget.foodSections[index].preparedAt,
        onSelectionChanged: (value) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(preparedAt: value);
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
    final formFieldKey = FormFieldType.consumeBy.createFormFieldKey(index);
    return [
      SectionHeader(
        title: Text(
          context.l10n!.consumeBy,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actionIcon: const Icon(Icons.today_rounded),
        onActionPressed: () async {
          final now = DateTime.now();
          final date = await DateTimePicker.pickDateTime(
            context: context,
            initial: widget.foodSections[index].consumeBy?.getDate() ??
                _consumeByInitialTime(),
            minimum: now,
          );

          if (date != null) {
            setState(() {
              final consumeBy = FoodDateTimeSpecified(date: date);
              widget.foodSections[index] =
                  widget.foodSections[index].copyWith(consumeBy: consumeBy);
            });
          }
        },
      ),
      const SizedBox(height: GapSize.xs),
      FoodDateTimeChips(
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        options: FoodDateTimeOption.createFutureOptions(context),
        selection: widget.foodSections[index].consumeBy,
        onSelectionChanged: (value) {
          widget.foodSections[index] =
              widget.foodSections[index].copyWith(consumeBy: value);
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

  Widget _buildFoodSection(
    FoodInfo offeredFood,
    int index,
  ) {
    final foodType = widget.foodSections[index].foodCategory?.type;
    return Column(
      key: ValueKey(offeredFood),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.l10n!.dish} ${index + 1}',
              style: const TextStyle(fontSize: FontSize.m),
            ),
            if (index != 0)
              RemoveSectionButton(
                onClick: () {
                  setState(() {
                    widget.foodSections.removeAt(index);
                    widget.checkboxValues.removeAt(index);
                  });
                },
              ),
          ],
        ),
        _buildGap(),
        ..._buildFoodNamePart(index),
        _buildGap(),
        ..._buildFoodAllergensPart(index),
        _buildGap(),
        ..._buildFoodCategoryPart(index),
        _buildGap(),
        if (foodType == FoodCategoryType.warm)
          Column(
            children: [
              ..._buildTemperaturePart(index),
              _buildGap(),
            ],
          ),
        ..._buildBoxTypesPart(index),
        _buildGap(),
        ..._buildNumberOfServingsPart(index),
        _buildGap(),
        if (foodType == FoodCategoryType.cooled)
          Column(
            children: [
              ..._buildPreparedAtPart(index),
              _buildGap(),
            ],
          ),
        ..._buildConsumeByPart(index),
        _buildGap(),
      ],
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.xl);
  }

  DateTime _consumeByInitialTime() {
    const offset = Duration(minutes: Constants.foodConsumeByMinutesOffset);
    return DateTime.now().add(offset);
  }
}
