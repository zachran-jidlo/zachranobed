import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/presentation/model/food_category.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/ui_meal_badge.dart';
import 'package:zachranobed/common/presentation/widget/ui_meal_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_date_time.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/usecase/get_history_paginated_use_case.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';

/// A screen that displays the paginated history of offered food donations.
///
/// This screen shows a chronologically organized list of past food donations,
/// grouped by date with section headers. Supports infinite scroll pagination
/// to load more items as the user scrolls down.
///
/// Features:
/// - Pull-to-refresh to reload the list
/// - Automatic pagination when scrolling near the bottom
/// - Empty state when no donations are available
/// - Error handling with retry functionality
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _useCase = GetIt.I<GetHistoryPaginatedUseCase>();
  final _scrollController = ScrollController();

  final List<SectionedListEntry<OfferedFood>> _items = [];
  DateTime? _lastItemDate;
  bool _isLoading = false;
  bool _isError = false;
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && _hasMore) {
      _loadData();
    }
  }

  Future<void> _loadInitialData() {
    return _loadData(initial: true);
  }

  Future<void> _loadData({
    bool initial = false,
  }) async {
    if (_isLoading) {
      // If already loading, do nothing
      return;
    }

    setState(() {
      _isLoading = true;
      _isError = false;

      if (initial) {
        _items.clear();
        _lastItemDate = null;
      }
    });

    try {
      final user = HelperService.getCurrentUser(context);
      if (user == null) {
        _setError();
        return;
      }

      final items = await _useCase.invoke(
        user: user,
        startAfterDate: initial ? null : _lastItemDate,
      );

      setState(() {
        _addItemsToEntries(items);

        _isLoading = false;
        _hasMore = items.isNotEmpty;
      });
    } catch (e) {
      _setError();
    }
  }

  void _addItemsToEntries(Iterable<OfferedFood> items) {
    for (final item in items) {
      final currentDateKey = _getDateHeader(item.date);
      final lastDateKey = _lastItemDate != null ? _getDateHeader(_lastItemDate!) : null;

      if (lastDateKey != currentDateKey) {
        _items.add(SectionedListHeader(currentDateKey));
      }

      _items.add(SectionedListItem(item));
      _lastItemDate = item.date;
    }
  }

  String _getDateHeader(DateTime date) {
    return DateTimeUtils.isToday(date) ? context.l10n.commonToday : DateTimeUtils.formatDateTime(date, "d. M. yyyy");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: UiAppBar(
        title: context.l10n.historyTitle,
        automaticallyImplyLeading: false,
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_items.isEmpty && _isLoading) {
      return LoadingPage();
    }

    if (_isError) {
      return ErrorPage(
        onRetryPressed: _loadInitialData,
      );
    }

    if (_items.isEmpty) {
      return InfoPage(
        image: ImageAssets.imageEmptyChef,
        title: context.l10n.donationsEmptyTitle,
        description: context.l10n.donationsEmptyDescription,
      );
    }

    return _HistoryList(
      items: _items,
      hasMore: _hasMore,
      onRefresh: _loadInitialData,
      controller: _scrollController,
    );
  }

  void _setError() {
    setState(() {
      _isError = true;
      _isLoading = false;
      _hasMore = false;
    });
  }
}

class _HistoryList extends StatelessWidget {
  final List<SectionedListEntry<OfferedFood>> items;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final ScrollController controller;

  const _HistoryList({
    required this.items,
    required this.hasMore,
    required this.onRefresh,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final entries = hasMore
        ? [
            ...items,
            const SectionedListItemWidget<OfferedFood>(
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ]
        : items;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SectionedListView<OfferedFood>.builder(
        controller: controller,
        entries: entries,
        itemBuilder: (context, item) {
          return _buildItem(context, item);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, OfferedFood item) {
    return UiMealTile(
      title: item.dishName,
      quantityLabel: _formatQuantity(context, item),
      badges: [
        _buildCategoryBadge(context, item),
        _buildAllergensBadge(context, item),
        _buildDateBadge(context, item),
      ],
    );
  }

  String _formatQuantity(BuildContext context, OfferedFood item) {
    if (item.numberOfServings != null) {
      return context.l10n.commonServingsCount(item.numberOfServings!);
    }
    if (item.numberOfPackages != null) {
      return context.l10n.foodInfoCountTemplate(item.numberOfPackages!);
    }
    return '';
  }

  UiMealBadge _buildCategoryBadge(BuildContext context, OfferedFood item) {
    return switch (item.foodCategoryType) {
      FoodCategoryType.warm => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconHot),
          label: context.l10n.foodCategoryBadgeWarmTemplate(item.foodTemperature ?? Constants.foodTemperatureInitial),
        ),
      FoodCategoryType.cooled => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconCold),
          label: context.l10n.foodCategoryBadgeCooled,
        ),
      FoodCategoryType.packaged => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconPack),
          label: context.l10n.foodCategoryBadgePackaged,
        ),
      null => UiMealBadge(
          icon: UiIconSpec.svg(ImageAssets.iconMeal),
          label: item.foodCategory,
        ),
    };
  }

  UiMealBadge _buildAllergensBadge(BuildContext context, OfferedFood item) {
    String allergensLabel;
    if (listEquals(item.allergens, [FoodAllergen.noAllergensNumber])) {
      allergensLabel = context.l10n.allergensNotPresent;
    } else if (listEquals(item.allergens, [FoodAllergen.onPackageNumber])) {
      allergensLabel = context.l10n.allergensListedOnPackage;
    } else {
      allergensLabel = item.allergens.join(', ');
    }
    return UiMealBadge(
      icon: UiIconSpec.svg(ImageAssets.iconAllergens),
      label: allergensLabel,
    );
  }

  UiMealBadge _buildDateBadge(BuildContext context, OfferedFood item) {
    final dateLabel = switch (item.consumeBy) {
      FoodDateTimeSpecified(date: final date) => DateTimeUtils.formatDateTime(date, "d.M.y HH:mm"),
      FoodDateTimeOnPackaging() => context.l10n.foodDateTimeLabelOnPackaging,
    };

    return UiMealBadge(
      icon: UiIconSpec.svg(ImageAssets.iconCalendar),
      label: dateLabel,
    );
  }
}
