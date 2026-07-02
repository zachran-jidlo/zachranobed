import 'package:flutter/material.dart';
import 'package:zachranobed/common/domain/model/normalized.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/domain/utils/string_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_card.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';
import 'package:zachranobed/common/presentation/widget/layout/content_with_loading.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_label_factory.dart';

/// A meal name input that shows a dropdown of meal suggestions while typing.
///
/// Wraps [UiTextField] and renders an overlay anchored below the field. The
/// dropdown appears once the query has at least [_minChars] characters and lists
/// [suggestions] whose name contains the query (case- and accent-insensitive).
/// When nothing matches, an info row is shown instead. Tapping a suggestion
/// fills the field with its name and reports it through [onSuggestionSelected],
/// so the parent can also prefill the allergens.
class MealNameAutocompleteField extends StatefulWidget {
  /// The meal suggestions to filter and offer.
  final Resource<List<MealSuggestion>> suggestions;

  /// The initial value of the field.
  final String? initialValue;

  /// The focus node for the field.
  final FocusNode focusNode;

  /// The label text of the field.
  final String? labelText;

  /// The validation function for form validation.
  final String? Function(String?)? onValidation;

  /// The callback triggered when the text changes.
  final ValueChanged<String> onChanged;

  /// The callback triggered when a suggestion is tapped.
  final ValueChanged<MealSuggestion> onSuggestionSelected;

  const MealNameAutocompleteField({
    super.key,
    required this.suggestions,
    required this.focusNode,
    required this.onChanged,
    required this.onSuggestionSelected,
    this.initialValue,
    this.labelText,
    this.onValidation,
  });

  @override
  State<MealNameAutocompleteField> createState() => _MealNameAutocompleteFieldState();
}

class _MealNameAutocompleteFieldState extends State<MealNameAutocompleteField> {
  static const int _minChars = 3;
  static const double _maxDropdownHeight = 240.0;

  final _layerLink = LayerLink();
  final _overlayController = OverlayPortalController();

  late final TextEditingController _controller;
  String _query = '';
  double _fieldWidth = 0;

  /// The normalized view of the current suggestion list, rebuilt only when the
  /// widget receives a new list.
  late NormalizedList<MealSuggestion> _normalized;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _query = widget.initialValue ?? '';
    _rebuildNormalized();
    widget.focusNode.addListener(_updateOverlay);
  }

  @override
  void didUpdateWidget(MealNameAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.suggestions, widget.suggestions)) {
      _rebuildNormalized();
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_updateOverlay);
    _controller.dispose();
    super.dispose();
  }

  /// Rebuilds the normalized suggestions from the current [widget.suggestions].
  void _rebuildNormalized() {
    _normalized = NormalizedList(widget.suggestions.getOrNull() ?? const [], (s) => s.name);
  }

  /// Suggestions matching the current query, or empty when the query is too
  /// short.
  List<MealSuggestion> _matches() {
    if (_query.searchNormalized.length < _minChars) {
      return const [];
    }
    return _normalized.matches(_query);
  }

  void _onChanged(String value) {
    _query = value;
    widget.onChanged(value);
    _updateOverlay();
  }

  void _onSuggestionSelected(MealSuggestion suggestion) {
    _controller.value = TextEditingValue(
      text: suggestion.name,
      selection: TextSelection.collapsed(offset: suggestion.name.length),
    );
    _query = suggestion.name;
    widget.onSuggestionSelected(suggestion);
    widget.focusNode.unfocus();
    _overlayController.hide();
  }

  void _updateOverlay() {
    if (widget.focusNode.hasFocus && _query.searchNormalized.length >= _minChars) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _fieldWidth = constraints.maxWidth;
            return UiTextField(
              controller: _controller,
              labelText: widget.labelText,
              focusNode: widget.focusNode,
              onValidation: widget.onValidation,
              onChanged: _onChanged,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned(
      width: _fieldWidth,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        // Treat taps on the dropdown as taps inside the field, so the field's
        // onTapOutside does not unfocus and dismiss the overlay before a
        // suggestion tap is handled.
        child: TextFieldTapRegion(
          child: _buildDropdown(context),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return UiCard(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      borderRadius: 4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _maxDropdownHeight),
        child: switch (widget.suggestions) {
          ResourceLoading() => _buildLoading(),
          ResourceSuccess() => _buildResults(context, _matches()),
          // A failed suggestion load is treated as no matches on purpose
          ResourceError() => _buildNotFound(context),
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context, List<MealSuggestion> matches) {
    if (matches.isEmpty) {
      return _buildNotFound(context);
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: matches.length,
      separatorBuilder: (_, __) {
        return Divider(
          height: 1,
          color: context.uiColors.surfaceGrayDark,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (context, index) {
        final item = matches[index];
        return _buildItem(
          context: context,
          title: item.name,
          subtitle: FoodAllergensLabelFactory.build(context, item.allergens),
          onTap: () => _onSuggestionSelected(item),
        );
      },
    );
  }

  Widget _buildLoading() {
    return ContentWithLoading(
      isLoading: true,
      // Just reuse item for fixed height
      child: _buildNotFound(context),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return _buildItem(
      context: context,
      title: context.l10n.mealNameAutocompleteFieldSuggestionNotFoundTitle,
      subtitle: context.l10n.mealNameAutocompleteFieldSuggestionNotFoundSubtitle,
    );
  }

  Widget _buildItem({
    required BuildContext context,
    VoidCallback? onTap,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
      highlightColor: context.uiColors.textPrimary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodyMedium.copyWith(
                color: onTap != null ? context.uiColors.textPrimary : context.uiColors.textSecondary,
              ),
            ),
            Text(
              subtitle,
              style: context.textStyles.bodySmall.copyWith(
                color: context.uiColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
