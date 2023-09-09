import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/enums/box_type.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/shipping_of_boxes.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/remove_section_button.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class ShippingOfBoxesSectionFields extends StatefulWidget {
  final List<ShippingOfBoxes> shippingSections;

  const ShippingOfBoxesSectionFields({
    super.key,
    required this.shippingSections,
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

  Widget _buildShippingSection(ShippingOfBoxes shipping, int index) {
    return Column(
      key: ValueKey(shipping),
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
        const SizedBox(height: GapSize.l),
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
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            widget.shippingSections[index] = widget.shippingSections[index]
                .copyWith(numberOfBoxes: val.isEmpty ? null : int.parse(val));
          },
          initialValue: shipping.numberOfBoxes?.toString(),
        ),
        const SizedBox(height: GapSize.l),
        ZODropdown(
          hintText: context.l10n!.boxType,
          items: BoxType.values
              .where((type) => type != BoxType.disposablePackaging)
              .map((type) => BoxTypeHelper.toValue(type, context))
              .toList(),
          onValidation: (val) =>
              val == null ? context.l10n!.requiredDropdownError : null,
          onChanged: (val) {
            widget.shippingSections[index] =
                widget.shippingSections[index].copyWith(boxType: val);
          },
          initialValue: shipping.boxType,
        ),
        const SizedBox(height: GapSize.l),
      ],
    );
  }
}
