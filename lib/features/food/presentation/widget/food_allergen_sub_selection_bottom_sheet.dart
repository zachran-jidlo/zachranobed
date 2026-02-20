import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_transparent_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_checkbox.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// A utility class for displaying a bottom sheet that allows selecting
/// specific sub-categories of a [FoodAllergen].
///
/// Returns the updated list of selected allergen keys when saved:
/// - If all sub-items are selected, returns the parent allergen number (e.g. ["1"]).
/// - If some sub-items are selected, returns the specific sub-item keys (e.g. ["1a", "1b"]).
/// - If none are selected, returns an empty list.
class FoodAllergenSubSelectionBottomSheet {
  FoodAllergenSubSelectionBottomSheet._();

  /// Shows the sub-category selection bottom sheet for [allergen].
  ///
  /// [currentSelection] is the full allergen selection list from the form.
  /// Returns the new allergen values for this group, or null if dismissed.
  static Future<List<String>?> show(
    BuildContext context, {
    required FoodAllergen allergen,
    required List<String> currentSelection,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints.tightFor(width: 640.0),
      builder: (context) => _FoodAllergenSubSelectionSheet(
        allergen: allergen,
        currentSelection: currentSelection,
      ),
    );
  }
}

class _FoodAllergenSubSelectionSheet extends StatefulWidget {
  final FoodAllergen allergen;
  final List<String> currentSelection;

  const _FoodAllergenSubSelectionSheet({
    required this.allergen,
    required this.currentSelection,
  });

  @override
  State<_FoodAllergenSubSelectionSheet> createState() => _FoodAllergenSubSelectionSheetState();
}

class _FoodAllergenSubSelectionSheetState extends State<_FoodAllergenSubSelectionSheet> {
  late List<bool> _subItemsChecked;

  @override
  void initState() {
    super.initState();
    _subItemsChecked = _initChecked();
  }

  List<bool> _initChecked() {
    final mainNumber = widget.allergen.number.toString();
    if (widget.currentSelection.contains(mainNumber)) {
      // All sub-items were previously selected as a group
      return List.filled(widget.allergen.subItems.length, true);
    }
    return widget.allergen.subItems
        .map((sub) => widget.currentSelection.contains("${widget.allergen.number}${sub.label}"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: context.uiColors.inactive,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.allergensList,
                    style: context.textStyles.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  UiListTransparentTile(
                    title: "${widget.allergen.number}. ${widget.allergen.text}",
                    end: AbsorbPointer(
                      child: UiCheckbox(
                        isChecked: _areAllChecked(),
                        onChanged: (_) {},
                      ),
                    ),
                    onPressed: _toggleParent,
                  ),
                  ...widget.allergen.subItems.expandIndexed((index, subItem) {
                    return [
                      divider,
                      UiListTransparentTile(
                        title: "${widget.allergen.number}${subItem.label} ${subItem.text}",
                        start: Icon(
                          Icons.remove,
                          size: 24,
                          color: context.uiColors.textPrimary,
                        ),
                        end: AbsorbPointer(
                          child: UiCheckbox(
                            isChecked: _subItemsChecked[index],
                            onChanged: (_) {},
                          ),
                        ),
                        onPressed: () => _toggleSubItem(index),
                      ),
                    ];
                  }),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: UiPrimaryButton(
            size: UiButtonSize.medium(fullWidth: true),
            text: context.l10n.allergensSave,
            onPressed: () => context.pop(_computeResult()),
          ),
        ),
      ],
    );
  }

  bool _areAllChecked() {
    return _subItemsChecked.every((c) => c);
  }

  void _toggleParent() {
    setState(() {
      final checkAll = !_areAllChecked();
      for (var i = 0; i < _subItemsChecked.length; i++) {
        _subItemsChecked[i] = checkAll;
      }
    });
  }

  void _toggleSubItem(int index) {
    setState(() {
      _subItemsChecked[index] = !_subItemsChecked[index];
    });
  }

  List<String> _computeResult() {
    if (_areAllChecked()) {
      return [widget.allergen.number.toString()];
    }
    return widget.allergen.subItems
        .whereIndexed((index, e) => _subItemsChecked[index])
        .map((e) => "${widget.allergen.number}${e.label}")
        .toList();
  }
}
