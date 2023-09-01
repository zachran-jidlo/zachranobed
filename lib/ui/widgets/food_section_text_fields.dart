import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/enums/boxType.dart';
import 'package:zachranobed/enums/foodCategory.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodSectionTextFields extends StatefulWidget {
  final List<OfferedFood> foodSections;
  final List<TextEditingController> controllers;

  const FoodSectionTextFields({
    super.key,
    required this.foodSections,
    required this.controllers,
  });

  @override
  State<FoodSectionTextFields> createState() => _FoodSectionTextFieldsState();
}

class _FoodSectionTextFieldsState extends State<FoodSectionTextFields> {
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
    OfferedFood offeredFood,
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
            if (index != 0) _removeButton(index),
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
        ZODropdown(
          hintText: context.l10n!.boxType,
          items: BoxType.values
              .map((e) => BoxTypeHelper.toValue(e, context))
              .toList(),
          onValidation: (val) =>
              val == null ? context.l10n!.requiredDropdownError : null,
          onChanged: (val) {
            widget.foodSections[index] =
                widget.foodSections[index].copyWith(boxType: val);
          },
          initialValue: offeredFood.boxType,
        ),
        _buildGap(),
        ZODateTimePicker(
          label: context.l10n!.consumeBy,
          icon: MaterialSymbols.calendar_today,
          controller: controller,
          onValidation: (val) =>
              val!.isEmpty ? context.l10n!.requiredFieldError : null,
          onTappedOutside: (val) {
            if (controller.text != '') {
              widget.foodSections[index] = widget.foodSections[index].copyWith(
                consumeBy: DateFormat('dd.MM.y HH:mm').parse(controller.text),
              );
            }
          },
        ),
        _buildGap(),
      ],
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.l);
  }

  Widget _removeButton(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.foodSections.removeAt(index);
          widget.controllers.removeAt(index);
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: ZOColors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: ZOColors.onSecondary,
          size: 20.0,
        ),
      ),
    );
  }
}
