import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/section_header.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/usecase/add_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';
import 'package:zachranobed/features/food/presentation/utils/form_validation_manager.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_chips.dart';
import 'package:zachranobed/features/food/presentation/widget/meal_name_autocomplete_field.dart';

/// A screen for manually adding a new meal suggestion.
///
/// On save it rejects duplicates (same normalized name and allergen set) with a
/// dialog, otherwise it stores the suggestion and returns to the list.
@RoutePage()
class MealSuggestionAddScreen extends StatefulWidget {
  const MealSuggestionAddScreen({super.key});

  @override
  State<MealSuggestionAddScreen> createState() => _MealSuggestionAddScreenState();
}

class _MealSuggestionAddScreenState extends State<MealSuggestionAddScreen> {
  static const _nameFieldKey = 'name';
  static const _allergensFieldKey = 'allergens';

  final _addMealSuggestion = GetIt.I<AddMealSuggestionUseCase>();
  final _getMealSuggestions = GetIt.I<GetMealSuggestionsUseCase>();
  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();

  Resource<List<MealSuggestion>> _suggestions = const ResourceLoading();
  String _name = '';
  List<String> _allergens = [];

  /// Bumped to reset the name and allergen inputs, e.g. when the user chooses to
  /// enter a different meal after a duplicate is reported.
  int _formVersion = 0;

  bool get _hasInput => _name.isNotEmpty || _allergens.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    final entityId = HelperService.getCurrentUser(context)?.entityId;
    if (entityId == null) {
      return;
    }
    try {
      final suggestions = await _getMealSuggestions.invoke(entityId: entityId);
      if (mounted) {
        setState(() => _suggestions = ResourceSuccess(suggestions));
      }
    } catch (error) {
      if (mounted) {
        setState(() => _suggestions = ResourceError(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.mealSuggestionAddTitle,
      ),
      builder: (context) {
        return PopScope(
          canPop: !_hasInput,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showDiscardDialog();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    ..._buildNamePart(),
                    const SizedBox(height: 32.0),
                    ..._buildAllergensPart(),
                    const SizedBox(height: 32.0),
                    _buildSaveButton(context),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildNamePart() {
    return [
      SectionHeader(title: context.l10n.foodName),
      const SizedBox(height: 16.0),
      MealNameAutocompleteField(
        key: ValueKey('$_nameFieldKey-$_formVersion'),
        suggestions: _suggestions,
        labelText: context.l10n.foodName,
        initialValue: _name,
        focusNode: _formValidationManager.getFocusNode(_nameFieldKey),
        onValidation: _formValidationManager.wrapValidator(
          _nameFieldKey,
          FieldValidationUtils.getFoodNameValidator(context),
        ),
        onChanged: (value) => setState(() => _name = value),
        onSuggestionSelected: (suggestion) {
          setState(() {
            _name = suggestion.name;
            _allergens = suggestion.allergens;
            _formVersion++;
          });
        },
      ),
    ];
  }

  List<Widget> _buildAllergensPart() {
    return [
      SectionHeader(
        title: context.l10n.allergens,
        action: UiIconButton.gradient(
          icon: Icons.info_outline_rounded,
          onPressed: () {
            final allergens = FoodAllergen.all(context);
            FoodAllergensBottomSheet.show(context, allergens, fullHeight: true);
          },
        ),
      ),
      const SizedBox(height: 16.0),
      FoodAllergensChips(
        key: ValueKey('$_allergensFieldKey-$_formVersion'),
        selection: _allergens,
        focusNode: _formValidationManager.getFocusNode(_allergensFieldKey),
        onSelectionChanged: (allergens) => setState(() => _allergens = allergens),
        onValidation: _formValidationManager.wrapValidator(
          _allergensFieldKey,
          FieldValidationUtils.getFoodAllergensValidator(context),
        ),
      ),
    ];
  }

  Widget _buildSaveButton(BuildContext context) {
    final isMobile = context.watch<AdaptiveLayoutConfig>().isMobile;
    return UiPrimaryButton(
      size: UiButtonSize.medium(fullWidth: isMobile),
      text: context.l10n.mealSuggestionAddSaveAction,
      onPressed: _onSavePressed,
    );
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) {
      _formValidationManager.scrollToFirstError();
      return;
    }

    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return;
    }

    UiDialog.showLoadingDialog(context);
    final result = await _addMealSuggestion.invoke(
      entityId: user.entityId,
      name: _name.trim(),
      allergens: _allergens,
    );
    if (!mounted) {
      return;
    }
    context.router.pop();

    switch (result) {
      case AddMealSuggestionResult.added:
        context.router.pop();
      case AddMealSuggestionResult.duplicate:
        _showDuplicateDialog();
      case AddMealSuggestionResult.failed:
        UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
    }
  }

  void _showDuplicateDialog() {
    showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.mealSuggestionDuplicateTitle,
        content: context.l10n.mealSuggestionDuplicateMessage,
        actions: [
          UiTextButton(
            text: context.l10n.mealSuggestionDuplicateBackAction,
            onPressed: () => context.router.maybePop(),
          ),
          UiPrimaryButton(
            text: context.l10n.mealSuggestionDuplicateNewAction,
            onPressed: () {
              context.router.maybePop();
              _clearForm();
            },
          ),
        ],
      ),
    );
  }

  void _showDiscardDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.mealSuggestionDiscardTitle,
        content: context.l10n.mealSuggestionDiscardMessage,
        actions: [
          UiTextButton(
            text: context.l10n.mealSuggestionDiscardCancelAction,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.mealSuggestionDiscardConfirmAction,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );

    if (mounted && (confirmed ?? false)) {
      context.router.pop();
    }
  }

  void _clearForm() {
    setState(() {
      _name = '';
      _allergens = [];
      _formVersion++;
    });
  }
}
