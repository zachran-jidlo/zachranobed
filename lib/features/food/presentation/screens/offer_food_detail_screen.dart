import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/presentation/utils/form_validation_manager.dart';
import 'package:zachranobed/features/food/presentation/widget/food_info_fields.dart';

/// Represents the initial screen for offering food.
///
/// This screen serves as the starting point for a user to begin the process of adding a new food offer. This screen
/// does not return a result, but instead navigates to the [OfferFoodOverviewScreen] screen.
@RoutePage()
class OfferFoodInitialScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen].
  const OfferFoodInitialScreen({super.key})
      : super(
          foodInfo: null,
          returnResult: false,
          screenMode: OfferFoodDetailScreenMode.add,
        );
}

/// Represents the screen for adding new food to the food offer.
///
/// This screen allows the user to fill in the details of a new food info and add it to the food offer. This screen
/// returns a result of type [OfferFoodDetailResultSaveItem] containing the newly added food info.
@RoutePage()
class OfferFoodAddNewScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen].
  const OfferFoodAddNewScreen({super.key})
      : super(
          foodInfo: null,
          returnResult: true,
          screenMode: OfferFoodDetailScreenMode.add,
        );
}

@RoutePage()
class OfferFoodEditExistingScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen] with the given [foodInfo].
  const OfferFoodEditExistingScreen({super.key, required FoodInfo foodInfo})
      : super(
          foodInfo: foodInfo,
          returnResult: true,
          screenMode: OfferFoodDetailScreenMode.edit,
        );
}

/// Represents the different modes of the [OfferFoodDetailScreen].
///
/// The [add] mode is used when creating a new food info, while the [edit] mode is used when editing an existing food
/// info.
enum OfferFoodDetailScreenMode {
  add,
  edit,
}

/// Sealed class for results of the [OfferFoodDetailScreen].
sealed class OfferFoodDetailResult {}

/// Result indicating that a food info was saved.
///
/// This result contains the [foodInfo] that was saved.
class OfferFoodDetailResultSaveItem extends OfferFoodDetailResult {
  final FoodInfo foodInfo;

  /// Creates a [OfferFoodDetailResultSaveItem] with the given [foodInfo].
  OfferFoodDetailResultSaveItem(this.foodInfo);
}

/// Result indicating that a food info was removed.
class OfferFoodDetailResultRemoveItem extends OfferFoodDetailResult {}

class OfferFoodDetailScreen extends StatefulWidget {
  final FoodInfo? foodInfo;
  final bool returnResult;
  final OfferFoodDetailScreenMode screenMode;

  const OfferFoodDetailScreen({
    super.key,
    required this.foodInfo,
    required this.returnResult,
    required this.screenMode,
  });

  @override
  State<OfferFoodDetailScreen> createState() => _OfferFoodDetailScreenState();
}

class _OfferFoodDetailScreenState extends State<OfferFoodDetailScreen> {
  late FoodInfo _foodInfoPending;

  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();
  final _getMealSuggestions = GetIt.I<GetMealSuggestionsUseCase>();

  Resource<List<MealSuggestion>> _mealSuggestions = const ResourceLoading();

  @override
  void initState() {
    super.initState();

    _foodInfoPending = widget.foodInfo ?? FoodInfo.withUuid();
    _loadMealSuggestions();
  }

  Future<void> _loadMealSuggestions() async {
    final entityId = HelperService.getCurrentUser(context)?.entityId;
    if (entityId == null) {
      // Runs synchronously within initState, so assign directly without setState.
      _mealSuggestions = const ResourceSuccess([]);
      return;
    }
    final result = await _getMealSuggestions.invoke(entityId: entityId).toResource();
    if (mounted) {
      setState(() => _mealSuggestions = result);
    }
  }

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.offerFoodDetailScreenTitle,
      ),
      builder: (context) {
        return PopScope(
          canPop: !_foodInfoPending.isSomethingFilled() || widget.foodInfo == _foodInfoPending,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showCancelConfirmationDialog();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FoodInfoFields(
                      formValidationManager: _formValidationManager,
                      foodInfo: _foodInfoPending,
                      mealSuggestions: _mealSuggestions,
                      onChanged: (food) {
                        setState(() {
                          _foodInfoPending = food;
                        });
                      },
                    ),
                    _buildBottomButtons(context),
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

  Widget _buildBottomButtons(BuildContext context) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    final actions = [
      if (widget.screenMode == OfferFoodDetailScreenMode.edit)
        UiOutlineButton(
          size: UiButtonSize.medium(fullWidth: isMobileLayout),
          icon: Icons.delete_outlined,
          text: context.l10n.offerFoodDetailRemoveButton,
          onPressed: () => _onRemoveFoodPressed(false),
        ),
      switch (widget.screenMode) {
        OfferFoodDetailScreenMode.add => UiPrimaryButton(
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            text: context.l10n.offerFoodDetailContinueButton,
            onPressed: _onConfirmationButtonPressed,
          ),
        OfferFoodDetailScreenMode.edit => UiPrimaryButton(
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            icon: Icons.check,
            text: context.l10n.offerFoodDetailSaveButton,
            onPressed: _onConfirmationButtonPressed,
          )
      },
    ];

    return Flex(
      spacing: 16.0,
      direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
      children: isMobileLayout ? actions : actions.reversed.toList(),
    );
  }

  void _onConfirmationButtonPressed() async {
    UiDialog.showLoadingDialog(context);

    if (_formKey.currentState!.validate()) {
      if (mounted) {
        // Remove dialog and return result
        context.router.pop();
        if (widget.returnResult) {
          context.router.pop(OfferFoodDetailResultSaveItem(_foodInfoPending));
        } else {
          context.router.replace(OfferFoodOverviewRoute(initialFoodInfos: [_foodInfoPending]));
        }
      }
    } else {
      if (mounted) {
        // Remove dialog and scroll to error
        context.router.pop();
        _formValidationManager.scrollToFirstError();
      }
    }
  }

  void _onRemoveFoodPressed(bool removeConfirmed) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.offerFoodFormRemoveDialogTitle,
        content: context.l10n.offerFoodFormRemoveDialogContent,
        actions: [
          UiTextButton(
            text: context.l10n.commonCancel,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.offerFoodFormRemoveDialogConfirmAction,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );

    if (mounted && confirmed) {
      context.router.pop(OfferFoodDetailResultRemoveItem());
    }
  }

  void _showCancelConfirmationDialog() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.cancelOffer,
        content: context.l10n.cancelOfferDialogContent,
        actions: [
          UiTextButton(
            text: context.l10n.continueTheOffer,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.confirmCancel,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );

    if (mounted && confirmed) {
      context.router.pop();
    }
  }
}
