import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/counter_field.dart';
import 'package:zachranobed/common/presentation/widget/section_header.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';
import 'package:zachranobed/features/food/presentation/utils/form_validation_manager.dart';

/// A widget that displays a counter for a specific type of food box.
class FoodBoxCounter extends StatelessWidget {
  /// The type of the food box.
  final FoodBoxType type;

  /// The initial value of the counter.
  final int initialValue;

  /// The maximum quantity available for this food box type.
  final int maxQuantity;

  /// Callback function triggered when the counter value changes.
  final Function(int)? onChanged;

  /// The form validation manager.
  final FormValidationManager formValidationManager;

  const FoodBoxCounter({
    super.key,
    required this.type,
    required this.maxQuantity,
    required this.initialValue,
    required this.onChanged,
    required this.formValidationManager,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: Text(
            type.name,
            style: context.textStyles.titleLarge,
          ),
          subtitle: Text(
            context.l10n.totalCountOfBoxes(maxQuantity),
            style: context.textStyles.titleSmall.copyWith(
              color: ZOColors.onBackgroundSecondary,
            ),
          ),
        ),
        const SizedBox(height: GapSize.xs),
        CounterField(
          label: context.l10n.numberOfBoxes,
          focusNode: formValidationManager.getFocusNode(type.id),
          onValidation: formValidationManager.wrapValidator(
            type.id,
            FieldValidationUtils.getBoxNumberValidator(
              context,
              allowZero: true,
              max: maxQuantity,
            ),
          ),
          initialValue: initialValue,
          maxValue: maxQuantity,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
