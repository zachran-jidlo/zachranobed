import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/enums/food_category.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/remove_section_button.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodSectionFields extends StatefulWidget {
  final List<FoodInfo> foodSections;
  final List<TextEditingController> controllers;
  final List<bool> checkboxValues;
  final List<FoodBoxType> boxTypes;

  const FoodSectionFields({
    super.key,
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
        ZOTextField(
          label: context.l10n!.foodName,
          onValidation: (val) =>
              val!.isEmpty ? context.l10n!.requiredFieldError : null,
          onChanged: (val) {
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(dishName: val);
          },
          initialValue: offeredFood.dishName,
        ),
        _buildGap(),
        ZOTextField(
          label: context.l10n!.allergens,
          onValidation: (val) {
            RegExp allergensRegex =
                RegExp(r'^(1[0-4]|[1-9])(,\s*(1[0-4]|[1-9]))*$');
            if (val!.isEmpty) {
              return context.l10n!.requiredFieldError;
            }
            if (!allergensRegex.hasMatch(val)) {
              return context.l10n!.invalidAllergensFormatError;
            }
            return null;
          },
          onChanged: (val) {
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(allergens: val.split(','));
          },
          initialValue: offeredFood.allergens
              ?.toString()
              .substring(1, offeredFood.allergens!.toString().length - 1),
          supportingText: context.l10n!.allergensSupportingText,
        ),
        _buildGap(),
        ZODropdown(
          hintText: context.l10n!.foodCategory,
          items: FoodCategory.values
              .map((e) => FoodCategoryHelper.toValue(e, context))
              .toList(),
          onValidation: (val) =>
              val == null ? context.l10n!.requiredDropdownError : null,
          onChanged: (val) {
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(foodCategory: val);
          },
          initialValue: offeredFood.foodCategory,
        ),
        _buildGap(),
        ZOTextField(
          label: context.l10n!.numberOfServings,
          onValidation: (val) {
            if (val!.isEmpty) {
              return context.l10n!.requiredFieldError;
            }
            int? validNumber = int.tryParse(val);
            if (validNumber == null) {
              return context.l10n!.invalidNumberError;
            }
            return null;
          },
          inputType: TextInputType.number,
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            widget.foodSections[index] = widget.foodSections[index].copyWith(
                numberOfServings: val.isEmpty ? null : int.parse(val));
          },
          initialValue: offeredFood.numberOfServings?.toString(),
        ),
        _buildGap(),
        ZOCheckbox(
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
                  ZOTextField(
                    label: context.l10n!.numberOfBoxes,
                    onValidation: (val) {
                      if (val!.isEmpty) {
                        return context.l10n!.requiredFieldError;
                      }
                      int? validNumber = int.tryParse(val);
                      if (validNumber == null) {
                        return context.l10n!.invalidNumberError;
                      }
                      return null;
                    },
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
        ZODropdown(
          hintText: context.l10n!.boxType,
          items: widget.boxTypes.map((type) => type.name).toList(),
          onValidation: (val) =>
              val == null ? context.l10n!.requiredDropdownError : null,
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
          onValidation: (val) =>
              val!.isEmpty ? context.l10n!.requiredFieldError : null,
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
    return const SizedBox(height: GapSize.m);
  }
}
