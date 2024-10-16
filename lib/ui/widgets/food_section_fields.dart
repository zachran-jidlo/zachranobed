import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/enums/food_form_field_type.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/ui/widgets/food_allergens_chips.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/remove_section_button.dart';
import 'package:zachranobed/ui/widgets/section_header.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodSectionFields extends StatefulWidget {
  final FormValidationManager formValidationManager;
  final List<FoodInfo> foodSections;
  final List<TextEditingController> controllers;
  final List<bool> checkboxValues;
  final List<FoodBoxType> boxTypes;

  const FoodSectionFields({
    super.key,
    required this.formValidationManager,
    required this.foodSections,
    required this.controllers,
    required this.checkboxValues,
    required this.boxTypes,
  });

  @override
  State<FoodSectionFields> createState() => _FoodSectionFieldsState();
}

class _FoodSectionFieldsState extends State<FoodSectionFields> {
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.foodSections.length; i++) {
      if (widget.foodSections[i].consumeBy != null) {
        widget.controllers[i].text = DateTimeUtils().formatDateTime(
            widget.foodSections[i].consumeBy!, "d.M.yyyy HH:mm");
      }
    }
  }

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
          widget.controllers[index],
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

  Widget _buildDropdown({
    required int index,
    required FormFieldType type,
    required final String hintText,
    required final List<String> items,
    required final String? Function(String?) onValidation,
    required final Function(String) onChanged,
    final String? initialValue,
  }) {
    final formFieldKey = type.createFormFieldKey(index);
    return ZODropdown(
      hintText: hintText,
      items: items,
      focusNode: widget.formValidationManager.getFocusNode(formFieldKey),
      onValidation: widget.formValidationManager.wrapValidator(
        formFieldKey,
        onValidation,
      ),
      onChanged: onChanged,
      initialValue: initialValue,
    );
  }

  List<Widget> _buildFoodNamePart(int index) {
    return [
      SectionHeader(
        text: context.l10n!.foodName,
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
        text: context.l10n!.allergens,
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

  Widget _buildFoodSection(
    FoodInfo offeredFood,
    int index,
    TextEditingController controller,
  ) {
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
                    widget.controllers.removeAt(index);
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
        _buildDropdown(
          index: index,
          type: FormFieldType.foodCategory,
          hintText: context.l10n!.foodCategory,
          items: FoodCategory.values
              .map((e) => FoodCategoryHelper.toValue(e, context))
              .toList(),
          onValidation: FieldValidationUtils.getFoodCategoryValidator(context),
          onChanged: (val) {
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(foodCategory: val);
          },
          initialValue: offeredFood.foodCategory,
        ),
        _buildGap(),
        _buildTextField(
          index: index,
          type: FormFieldType.numberOfServings,
          label: context.l10n!.numberOfServings,
          onValidation: FieldValidationUtils.getServingsValidator(context),
          inputType: TextInputType.number,
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            widget.foodSections[index] = widget.foodSections[index].copyWith(
                numberOfServings: val.isEmpty ? null : int.parse(val));
          },
          initialValue: offeredFood.numberOfServings?.toString(),
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
        _buildGap(),
        !widget.checkboxValues[index]
            ? Column(
                children: [
                  _buildTextField(
                    index: index,
                    type: FormFieldType.numberOfBoxes,
                    label: context.l10n!.numberOfBoxes,
                    onValidation: FieldValidationUtils.getBoxNumberValidator(
                      context,
                    ),
                    inputType: TextInputType.number,
                    textInputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (val) {
                      widget.foodSections[index] = widget.foodSections[index]
                          .copyWith(
                              numberOfBoxes:
                                  val.isEmpty ? null : int.parse(val));
                    },
                    initialValue: offeredFood.numberOfBoxes?.toString(),
                  ),
                  _buildGap(),
                ],
              )
            : const SizedBox(),
        _buildDropdown(
          index: index,
          type: FormFieldType.boxType,
          hintText: context.l10n!.boxType,
          items: widget.boxTypes.map((type) => type.name).toList(),
          onValidation: FieldValidationUtils.getBoxTypeValidator(context),
          onChanged: (val) {
            final type = widget.boxTypes.firstWhereOrNull((e) => e.name == val);
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(foodBoxId: type?.id);
          },
          initialValue: widget.boxTypes
              .firstWhereOrNull((e) => e.id == offeredFood.foodBoxId)
              ?.name,
        ),
        _buildGap(),
        ZODateTimePicker(
          label: context.l10n!.consumeBy,
          icon: MaterialSymbols.calendar_today,
          controller: controller,
          minimumDate: DateTime.now(),
          focusNode: widget.formValidationManager.getFocusNode(
            FormFieldType.consumeBy.createFormFieldKey(index),
          ),
          onValidation: widget.formValidationManager.wrapValidator(
            FormFieldType.consumeBy.createFormFieldKey(index),
            FieldValidationUtils.getConsumeByValidator(context),
          ),
          onDateTimePicked: (date) {
            if (date != null) {
              widget.foodSections[index] = widget.foodSections[index].copyWith(
                consumeBy: date,
              );
            }
          },
        ),
        _buildGap(),
      ],
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.xl);
  }
}
