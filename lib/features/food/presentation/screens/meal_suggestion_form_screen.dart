import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
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
import 'package:zachranobed/features/food/domain/usecase/check_meal_suggestion_duplicate_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/delete_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/update_meal_suggestion_use_case.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';
import 'package:zachranobed/features/food/presentation/utils/form_validation_manager.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_chips.dart';
import 'package:zachranobed/features/food/presentation/widget/meal_name_autocomplete_field.dart';

/// Whether the form creates a new meal suggestion or edits an existing one.
sealed class MealSuggestionFormMode {
  const MealSuggestionFormMode();
}

/// Adding a new meal suggestion.
class MealSuggestionFormAddMode extends MealSuggestionFormMode {
  const MealSuggestionFormAddMode();
}

/// Editing the given [suggestion].
class MealSuggestionFormEditMode extends MealSuggestionFormMode {
  final MealSuggestion suggestion;

  const MealSuggestionFormEditMode(this.suggestion);
}

/// Form for creating or editing a meal suggestion.
///
/// Saving rejects duplicates (same normalized name and allergen set) with a
/// dialog. In edit mode the suggestion can also be deleted.
class MealSuggestionFormScreen extends StatefulWidget {
  final MealSuggestionFormMode mode;

  const MealSuggestionFormScreen({super.key, required this.mode});

  @override
  State<MealSuggestionFormScreen> createState() => _MealSuggestionFormScreenState();
}

/// Adds a new meal suggestion.
@RoutePage()
class MealSuggestionAddScreen extends MealSuggestionFormScreen {
  const MealSuggestionAddScreen({super.key}) : super(mode: const MealSuggestionFormAddMode());
}

/// Edits an existing meal suggestion.
@RoutePage()
class MealSuggestionEditScreen extends MealSuggestionFormScreen {
  MealSuggestionEditScreen({super.key, required MealSuggestion suggestion})
      : super(mode: MealSuggestionFormEditMode(suggestion));
}

class _MealSuggestionFormScreenState extends State<MealSuggestionFormScreen> {
  static const _nameFieldKey = 'name';
  static const _allergensFieldKey = 'allergens';

  final _addMealSuggestion = GetIt.I<AddMealSuggestionUseCase>();
  final _updateMealSuggestion = GetIt.I<UpdateMealSuggestionUseCase>();
  final _deleteMealSuggestion = GetIt.I<DeleteMealSuggestionUseCase>();
  final _checkMealSuggestionDuplicate = GetIt.I<CheckMealSuggestionDuplicateUseCase>();
  final _getMealSuggestions = GetIt.I<GetMealSuggestionsUseCase>();
  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();

  Resource<List<MealSuggestion>> _suggestions = const ResourceLoading();
  late String _name;
  late List<String> _allergens;

  /// Bumped to reset the name and allergen inputs, e.g. when the user chooses to
  /// enter a different meal after a duplicate is reported.
  int _formVersion = 0;

  bool get _isEdit => widget.mode is MealSuggestionFormEditMode;

  bool get _hasUnsavedChanges {
    return switch (widget.mode) {
      MealSuggestionFormAddMode() => _name.isNotEmpty || _allergens.isNotEmpty,
      MealSuggestionFormEditMode(:final suggestion) => _name.trim() != suggestion.name ||
          !const SetEquality<String>().equals(_allergens.toSet(), suggestion.allergens.toSet()),
    };
  }

  @override
  void initState() {
    super.initState();
    switch (widget.mode) {
      case MealSuggestionFormAddMode():
        _name = '';
        _allergens = [];
      case MealSuggestionFormEditMode(:final suggestion):
        _name = suggestion.name;
        _allergens = List.of(suggestion.allergens);
    }
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
    final result = await _getMealSuggestions.invoke(entityId: entityId).toResource();
    if (mounted) {
      setState(() => _suggestions = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: _isEdit ? context.l10n.mealSuggestionFormEditTitle : context.l10n.mealSuggestionFormAddTitle,
      ),
      builder: (context) {
        return PopScope(
          canPop: !_hasUnsavedChanges,
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
                    ..._buildNamePart(),
                    const SizedBox(height: 32.0),
                    ..._buildAllergensPart(),
                    const SizedBox(height: 24.0),
                    ..._buildButtons(context),
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

  List<Widget> _buildButtons(BuildContext context) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    return [
      Flex(
        spacing: 16.0,
        direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
        children: _isEdit //
            ? [
                UiOutlineButton(
                  size: UiButtonSize.medium(fullWidth: isMobileLayout),
                  text: context.l10n.mealSuggestionFormDeleteAction,
                  onPressed: _onDeletePressed,
                ),
                UiPrimaryButton(
                  size: UiButtonSize.medium(fullWidth: isMobileLayout),
                  text: context.l10n.mealSuggestionFormEditSaveAction,
                  onPressed: _onSavePressed,
                ),
              ]
            : [
                UiPrimaryButton(
                  size: UiButtonSize.medium(fullWidth: isMobileLayout),
                  text: context.l10n.mealSuggestionFormAddSaveAction,
                  onPressed: _onSavePressed,
                ),
              ],
      )
    ];
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

    final mode = widget.mode;
    final name = _name.trim();

    UiDialog.showLoadingDialog(context);

    final existing = await _resolveExistingSuggestions(user.entityId);
    if (!mounted) {
      return;
    }
    if (existing == null) {
      context.router.pop();
      UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
      return;
    }

    final excludeId = mode is MealSuggestionFormEditMode ? mode.suggestion.id : null;
    final isDuplicate = _checkMealSuggestionDuplicate.invoke(
      existing: existing,
      name: name,
      allergens: _allergens,
      excludeId: excludeId,
    );
    if (isDuplicate) {
      context.router.pop();
      _showDuplicateDialog();
      return;
    }

    final success = await switch (mode) {
      MealSuggestionFormAddMode() => //
        _addMealSuggestion.invoke(
          entityId: user.entityId,
          name: name,
          allergens: _allergens,
        ),
      MealSuggestionFormEditMode(:final suggestion) => //
        _updateMealSuggestion.invoke(
          entityId: user.entityId,
          suggestion: MealSuggestion(id: suggestion.id, name: name, allergens: _allergens),
        ),
    };
    if (!mounted) {
      return;
    }
    context.router.pop();

    if (success) {
      context.router.pop();
    } else {
      UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
    }
  }

  /// Returns the suggestions to check duplicates against, or null when they
  /// cannot be obtained.
  ///
  /// Reuses the list already loaded for the autocomplete when available. When
  /// that load is still pending or has failed, fetches a fresh list so the
  /// duplicate check is not silently skipped on the load it depends on.
  Future<List<MealSuggestion>?> _resolveExistingSuggestions(String entityId) async {
    final loaded = _suggestions.getOrNull();
    if (loaded != null) {
      return loaded;
    }
    try {
      return await _getMealSuggestions.invoke(entityId: entityId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _onDeletePressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.mealSuggestionFormDeleteTitle,
        content: context.l10n.mealSuggestionFormDeleteMessage,
        actions: [
          UiTextButton(
            text: context.l10n.commonCancel,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.mealSuggestionFormDeleteAction,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) {
      return;
    }
    final mode = widget.mode;
    final user = HelperService.getCurrentUser(context);
    if (mode is! MealSuggestionFormEditMode || user == null) {
      return;
    }

    UiDialog.showLoadingDialog(context);
    final success = await _deleteMealSuggestion.invoke(
      entityId: user.entityId,
      id: mode.suggestion.id,
    );
    if (!mounted) {
      return;
    }
    context.router.pop();

    if (success) {
      context.router.pop();
    } else {
      UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
    }
  }

  void _showDuplicateDialog() {
    showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.mealSuggestionFormDuplicateTitle,
        content: context.l10n.mealSuggestionFormDuplicateMessage,
        actions: _isEdit
            ? [
                UiPrimaryButton(
                  text: context.l10n.mealSuggestionFormDuplicateBackAction,
                  onPressed: () => context.router.maybePop(),
                ),
              ]
            : [
                UiTextButton(
                  text: context.l10n.mealSuggestionFormDuplicateBackAction,
                  onPressed: () => context.router.maybePop(),
                ),
                UiPrimaryButton(
                  text: context.l10n.mealSuggestionFormDuplicateNewAction,
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
        title: context.l10n.mealSuggestionFormDiscardTitle,
        content: context.l10n.mealSuggestionFormDiscardMessage,
        actions: [
          UiTextButton(
            text: context.l10n.mealSuggestionFormDiscardCancelAction,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.mealSuggestionFormDiscardConfirmAction,
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
