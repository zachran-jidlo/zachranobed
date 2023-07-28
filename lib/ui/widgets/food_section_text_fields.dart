import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class FoodSectionTextFields extends StatefulWidget {
  final List<FoodInfo> foodSections;

  const FoodSectionTextFields({super.key, required this.foodSections});

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
        return _buildFoodSection(widget.foodSections[index], index);
      },
    );
  }

  Widget _buildFoodSection(FoodInfo foodInfo, int index) {
    return Column(
      key: ValueKey(foodInfo),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.l10n!.dish} ${index + 1}',
              style: const TextStyle(fontSize: FontSize.m),
            ),
            if (index != 0) _removeButton(foodInfo),
          ],
        ),
        _buildGap(),
        ZOTextField(
          label: context.l10n!.foodName,
          onValidation: (val) =>
              val!.isEmpty ? context.l10n!.requiredFieldError : null,
          onChanged: (val) => foodInfo.dishName = val,
          value: foodInfo.dishName,
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
          onChanged: (val) => foodInfo.allergens = val.split(','),
          value: foodInfo.allergens?.toString(),
          supportingText: context.l10n!.allergensSupportingText,
        ),
        const SizedBox(height: 28),
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
          onChanged: (val) =>
              foodInfo.numberOfServings = val.isEmpty ? null : int.parse(val),
          value: foodInfo.numberOfServings?.toString(),
        ),
        _buildGap(),
      ],
    );
  }

  Widget _buildGap() {
    return const SizedBox(height: GapSize.l);
  }

  Widget _removeButton(FoodInfo foodInfo) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.foodSections.remove(foodInfo);
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
