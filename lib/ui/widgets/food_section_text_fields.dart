import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              '${ZachranObedStrings.food} ${index + 1}',
              style: const TextStyle(fontSize: 22),
            ),
            if (index != 0) _removeButton(foodInfo),
          ],
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.foodName,
          onValidation: (val) =>
              val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
          onChanged: (val) => foodInfo.name = val,
          value: foodInfo.name,
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.allergens,
          onValidation: (val) =>
              val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
          onChanged: (val) => foodInfo.allergens = val,
          value: foodInfo.allergens,
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.numberOfServings,
          onValidation: (val) {
            if (val!.isEmpty) {
              return ZachranObedStrings.requiredFieldError;
            }
            int? validNumber = int.tryParse(val);
            if (validNumber == null) {
              return ZachranObedStrings.invalidNumberError;
            }
            return null;
          },
          inputType: TextInputType.number,
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) =>
              foodInfo.numberOfServings = val.isEmpty ? null : int.parse(val),
          value: foodInfo.numberOfServings?.toString(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _removeButton(FoodInfo foodInfo) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.foodSections.remove(foodInfo);
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}