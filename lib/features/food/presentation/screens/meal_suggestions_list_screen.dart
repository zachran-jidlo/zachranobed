import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/resource.dart';
import 'package:zachranobed/common/domain/utils/string_utils.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_fill_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_text_field.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_meal_suggestions_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/meal_allergens_label_factory.dart';

/// A screen that lists the entity's saved meal suggestions.
///
/// Suggestions are observed live and can be filtered with a case- and
/// accent-insensitive search.
@RoutePage()
class MealSuggestionsListScreen extends StatefulWidget {
  const MealSuggestionsListScreen({super.key});

  @override
  State<MealSuggestionsListScreen> createState() => _MealSuggestionsListScreenState();
}

class _MealSuggestionsListScreenState extends State<MealSuggestionsListScreen> {
  final _observeMealSuggestions = GetIt.I<ObserveMealSuggestionsUseCase>();

  Resource<List<MealSuggestion>> _suggestions = const ResourceLoading();
  String _query = '';
  StreamSubscription<List<MealSuggestion>>? _subscription;

  @override
  void initState() {
    super.initState();
    final entityId = HelperService.getCurrentUser(context)?.entityId;
    if (entityId == null) {
      return;
    }
    _subscription = _observeMealSuggestions.invoke(entityId: entityId).listen(
      (suggestions) async {
        if (mounted) {
          setState(() => _suggestions = ResourceSuccess(suggestions));
        }
      },
      onError: (Object error) {
        if (mounted) {
          setState(() => _suggestions = ResourceError(error));
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: UiAppBar(
        title: context.l10n.mealSuggestionsListTitle,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: UiIconFillButton(
              icon: Icons.add,
              onPressed: () => context.router.push(const MealSuggestionAddRoute()),
            ),
          ),
        ],
      ),
      child: switch (_suggestions) {
        ResourceLoading() => LoadingPage(),
        ResourceError() => const ErrorPage(),
        ResourceSuccess(:final data) => _buildContent(data),
      },
    );
  }

  Widget _buildContent(List<MealSuggestion> data) {
    if (data.isEmpty) {
      return InfoPage(
        image: ImageAssets.imageEmptyMeals,
        title: context.l10n.mealSuggestionsListEmptyTitle,
        description: context.l10n.mealSuggestionsListEmptyDescription,
      );
    }

    final query = _query.searchNormalized;
    final filtered = query.isNotEmpty
        ? data.where((s) => s.name.searchNormalized.contains(query)).toList()
        : data;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: UiTextField(
            hintText: context.l10n.mealSuggestionsListSearchHint,
            leadingIcon: Icons.search,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: filtered.isNotEmpty ? _buildList(filtered) : _buildNothingFound(),
        ),
      ],
    );
  }

  Widget _buildNothingFound() {
    return Center(
      child: Text(
        context.l10n.mealSuggestionsListNothingFound,
        textAlign: TextAlign.center,
        style: context.textStyles.bodyLarge.copyWith(
          color: context.uiColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildList(List<MealSuggestion> suggestions) {
    return SectionedListView<MealSuggestion>.builder(
      entries: suggestions.map((s) => SectionedListItem(s)).toList(),
      itemBuilder: _buildRow,
    );
  }

  Widget _buildRow(BuildContext context, MealSuggestion suggestion) {
    return UiListTile(
      title: suggestion.name,
      supportingText: MealAllergensLabelFactory.build(context, suggestion.allergens),
      end: UiGradientIcon(
        gradient: context.uiColors.primaryGradient,
        spec: const UiIconSpec.data(Icons.chevron_right),
      ),
      onPressed: () {
        // TODO: navigate to the meal edit screen once it is implemented.
      },
    );
  }
}
