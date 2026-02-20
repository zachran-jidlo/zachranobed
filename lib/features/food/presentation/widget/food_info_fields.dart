import 'package:flutter/material.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';
import 'package:zachranobed/common/presentation/model/food_category.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/chip/single_select_chips.dart';
import 'package:zachranobed/common/presentation/widget/form/date_time_picker.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';
import 'package:zachranobed/common/presentation/widget/layout/section_header.dart';
import 'package:zachranobed/features/food/domain/model/food_date_time.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';
import 'package:zachranobed/features/food/presentation/model/food_form_field_type.dart';
import 'package:zachranobed/features/food/presentation/utils/form_validation_manager.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergen_sub_items_label.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_chips.dart';
import 'package:zachranobed/features/food/presentation/widget/food_date_time_chips.dart';

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
        title: context.l10n.foodName,
      ),
      const SizedBox(height: 16.0),
      UiTextField(
        key: ValueKey(formFieldKey),
        labelText: context.l10n.foodName,
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
        title: context.l10n.allergens,
        action: UiIconButton.gradient(
          icon: Icons.info_outline_rounded,
          onPressed: () {
            final allergens = FoodAllergen.all(context);
            FoodAllergensBottomSheet.show(context, allergens, fullHeight: true);
          },
        ),
      ),
      const SizedBox(height: 16.0),
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
      FoodAllergenSubItemsLabel(
        currentSelection: widget.foodInfo.allergens ?? [],
      ),
    ];
  }

  List<Widget> _buildFoodCategoryPart(int index) {
    final formFieldKey = _createFormFieldKey(FormFieldType.foodCategory);
    return [
      SectionHeader(
        title: context.l10n.foodCategory,
      ),
      const SizedBox(height: 16.0),
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
        title: context.l10n.foodTemperature,
      ),
      const SizedBox(height: 16.0),
      UiCounterField(
        key: ValueKey(formFieldKey),
        label: context.l10n.foodTemperatureWithCelsius,
        minValue: Constants.foodTemperatureMin,
        maxValue: Constants.foodTemperatureMax,
        noValueFallback: Constants.foodTemperatureInitial,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getFoodTemperatureValidator(context),
        ),
        value: widget.foodInfo.foodTemperature ?? Constants.foodTemperatureInitial,
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
        title: context.l10n.numberOfServings,
      ),
      const SizedBox(height: 16.0),
      UiCounterField(
        key: ValueKey(keyServings),
        label: context.l10n.numberOfServings,
        focusNode: widget.formValidationManager.getFocusNode(keyServings),
        onValidation: widget.formValidationManager.wrapValidator(
          keyServings,
          FieldValidationUtils.getServingsValidator(context),
        ),
        value: widget.foodInfo.numberOfServings ?? 0,
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
        title: context.l10n.numberOfPackages,
      ),
      const SizedBox(height: 16.0),
      UiCounterField(
        key: ValueKey(formFieldKey),
        label: context.l10n.numberOfPackages,
        focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
        onValidation: widget.formValidationManager.wrapValidator(
          formFieldKey,
          FieldValidationUtils.getPackagesValidator(context),
        ),
        value: widget.foodInfo.numberOfPackages ?? 0,
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
        title: context.l10n.preparedAt,
      ),
      const SizedBox(height: 16.0),
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
          getPreparedAtValidator(context),
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
        title: context.l10n.consumeBy,
        action: UiIconButton.gradient(
          icon: Icons.today_rounded,
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
      const SizedBox(height: 16.0),
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
          getConsumeByValidator(context),
        ),
        formatSelectedDate: context.l10n.consumeByTemplate,
        initialTime: _consumeByInitialTime,
      ),
    ];
  }

  Widget _buildGap() {
    return const SizedBox(height: 32.0);
  }

  DateTime _consumeByInitialTime() {
    const offset = Duration(minutes: Constants.foodConsumeByMinutesOffset);
    return DateTime.now().add(offset);
  }

  String _createFormFieldKey(FormFieldType type) {
    return "food${widget.foodInfo.id}-field${type.name.toUpperCase()}";
  }

  /// Returns a validator for consume by field.
  /// The validator checks if the value is set and date is not in the past.
  static String? Function(FoodDateTime?) getConsumeByValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null) {
        return context.l10n.invalidFieldConsumeBy;
      }
      final now = DateTime.now();
      if (value is FoodDateTimeSpecified && value.date.isBefore(now)) {
        return context.l10n.invalidFieldConsumeByDateInPast;
      }
      return null;
    };
  }

  /// Returns a validator for prepared at field.
  /// The validator checks if the value is set and date is not in the future.
  static String? Function(FoodDateTime?) getPreparedAtValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null) {
        return context.l10n.invalidFieldPreparedAt;
      }
      final now = DateTime.now();
      if (value is FoodDateTimeSpecified && value.date.isAfter(now)) {
        return context.l10n.invalidFieldPreparedAtDateInPast;
      }
      return null;
    };
  }
}
