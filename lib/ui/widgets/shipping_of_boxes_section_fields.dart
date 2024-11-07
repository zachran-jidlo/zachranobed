import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/remove_section_button.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class ShippingOfBoxesSectionFields extends StatefulWidget {
  final List<BoxInfo> shippingSections;
  final List<FoodBoxType> boxTypes;

  const ShippingOfBoxesSectionFields({
    super.key,
    required this.shippingSections,
    required this.boxTypes,
  });

  @override
  State<ShippingOfBoxesSectionFields> createState() =>
      _ShippingOfBoxesSectionFieldsState();
}

class _ShippingOfBoxesSectionFieldsState
    extends State<ShippingOfBoxesSectionFields> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.shippingSections.length,
      itemBuilder: (context, index) {
        return _buildShippingSection(widget.shippingSections[index], index);
      },
    );
  }

  Widget _buildShippingSection(BoxInfo info, int index) {
    return Column(
      key: ValueKey(info),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.l10n!.boxes} ${index + 1}',
              style: const TextStyle(fontSize: FontSize.m),
            ),
            if (index != 0)
              RemoveSectionButton(
                onClick: () {
                  setState(() {
                    widget.shippingSections.removeAt(index);
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: GapSize.xl),
        ZOTextField(
          label: context.l10n!.numberOfBoxes,
          onValidation: FieldValidationUtils.getBoxNumberValidator(context),
          inputType: TextInputType.number,
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            widget.shippingSections[index] = widget.shippingSections[index]
                .copyWith(numberOfBoxes: val.isEmpty ? null : int.parse(val));
          },
          initialValue: info.numberOfBoxes?.toString(),
        ),
        const SizedBox(height: GapSize.m),
        ZODropdown(
          hintText: context.l10n!.boxType,
          items: widget.boxTypes.map((type) => type.name).toList(),
          onValidation: FieldValidationUtils.getBoxTypeByIdValidator(context),
          onChanged: (val) {
            final type = widget.boxTypes.firstWhereOrNull((e) => e.name == val);
            widget.shippingSections[index] =
                widget.shippingSections[index].copyWith(foodBoxId: type?.id);
          },
          initialValue: widget.boxTypes
              .firstWhereOrNull((e) => e.id == info.foodBoxId)
              ?.name,
        ),
        const SizedBox(height: GapSize.xl),
      ],
    );
  }
}
