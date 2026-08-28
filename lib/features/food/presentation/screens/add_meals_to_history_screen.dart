import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/food_category.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_box_counter_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/features/food/domain/model/food_date_time.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/usecase/add_meals_to_history_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestions_use_case.dart';

/// Lets entities with manual donation entry enabled record meals straight into
/// history, bypassing the delivery process.
///
/// Lists the donor's meal suggestions, each with a count field. On submit the
/// user confirms the counts in a dialog, and meals with a count above zero are
/// saved into today's history. Pops with `true` when meals were saved so the
/// caller can refresh the history list.
@RoutePage()
class AddMealsToHistoryScreen extends StatefulWidget {
  const AddMealsToHistoryScreen({super.key});

  @override
  State<AddMealsToHistoryScreen> createState() => _AddMealsToHistoryScreenState();
}

class _AddMealsToHistoryScreenState extends State<AddMealsToHistoryScreen> {
  final _getMealSuggestions = GetIt.I<GetMealSuggestionsUseCase>();
  final _addMealsToHistory = GetIt.I<AddMealsToHistoryUseCase>();

  Resource<List<MealSuggestion>> _suggestions = const ResourceLoading();

  /// Per-suggestion count edited by the user, keyed by suggestion id.
  final Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      setState(() => _suggestions = const ResourceError());
      return;
    }

    // Meal suggestions belong to the donor. A charity records what its donor
    // sent, so both roles read the active pair's donor suggestions.
    setState(() => _suggestions = const ResourceLoading());
    final result = await _getMealSuggestions.invoke(entityId: user.activePair.donorId).toResource();
    if (mounted) {
      setState(() => _suggestions = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(title: context.l10n.addMealsToHistoryScreenTitle),
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_suggestions) {
      case ResourceLoading():
        return const LoadingPage();
      case ResourceError():
        return ErrorPage(onRetryPressed: _loadSuggestions);
      case ResourceSuccess(:final data):
        if (data.isEmpty) {
          return _buildEmptyPage(context);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildList(context, data)),
            _buildBottomButton(context),
          ],
        );
    }
  }

  Widget _buildEmptyPage(BuildContext context) {
    final user = HelperService.getCurrentUser(context)!;
    return InfoPage(
      image: ImageAssets.imageEmptyMeals,
      title: context.l10n.addMealsToHistoryEmptyTitle,
      description: switch (user) {
        Canteen() => context.l10n.addMealsToHistoryEmptyCanteenDescription,
        Charity() => context.l10n.addMealsToHistoryEmptyCharityDescription,
      },
      actions: user is Canteen
          ? [
              UiOutlineButton(
                size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
                text: context.l10n.addMealsToHistoryEmptyAction,
                onPressed: () => context.replaceRoute(const ProfileRoute()),
              ),
            ]
          : [],
    );
  }

  Widget _buildList(BuildContext context, List<MealSuggestion> suggestions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: suggestions.map((suggestion) => _buildTile(context, suggestion)).toList(),
      ),
    );
  }

  Widget _buildTile(BuildContext context, MealSuggestion suggestion) {
    return UiBoxCounterTile(
      title: suggestion.name,
      counterField: UiCounterField(
        label: context.l10n.addMealsToHistoryCountLabel,
        value: _counts[suggestion.id] ?? 0,
        onChanged: (value) {
          setState(() {
            _counts[suggestion.id] = value;
          });
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: UiPrimaryButton(
        text: context.l10n.addMealsToHistorySaveAction,
        size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
        enabled: _counts.values.any((count) => count > 0),
        onPressed: () => _onSavePressed(context),
      ),
    );
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final suggestions = _suggestions.getOrNull() ?? [];
    final selected = suggestions.where((s) => (_counts[s.id] ?? 0) > 0).toList();
    if (selected.isEmpty) {
      return;
    }

    final confirmed = await _showConfirmationDialog(context, selected);
    if (!context.mounted || confirmed != true) {
      return;
    }

    final user = HelperService.getCurrentUser(context)!;

    // This quick flow only captures a count per meal. The rest is fixed to the
    // piece-based defaults: packaged category counted in pieces, and consume-by
    // read from the packaging. Allergens come from the suggestion.
    final foodInfo = selected.map((suggestion) {
      return FoodInfo.withUuid(
        dishName: suggestion.name,
        allergens: suggestion.allergens,
        foodCategory: FoodCategory(
          name: context.l10n.foodCategoryPackaged,
          type: FoodCategoryType.packaged,
        ),
        numberOfPackages: _counts[suggestion.id],
        consumeBy: FoodDateTimeOnPackaging(),
      );
    }).toList();

    UiDialog.showLoadingDialog(context);
    final success = await _addMealsToHistory.invoke(user: user, foodInfo: foodInfo);
    if (!context.mounted) {
      return;
    }
    context.router.pop();

    if (success) {
      context.router.maybePop(true);
    } else {
      UiTemporarySnackBar.showError(context, message: context.l10n.somethingWentWrongError);
    }
  }

  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    List<MealSuggestion> selected,
  ) {
    final items = selected
        .map((s) => context.l10n.addMealsToHistoryDialogItemTemplate(_counts[s.id] ?? 0, s.name))
        .join('\n');
    final content = '${context.l10n.addMealsToHistoryDialogDescription}\n\n$items';

    return showDialog<bool>(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.addMealsToHistoryDialogTitle,
        content: content,
        actions: [
          UiTextButton(
            text: context.l10n.addMealsToHistoryDialogEditAction,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.addMealsToHistoryDialogConfirmAction,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );
  }
}
