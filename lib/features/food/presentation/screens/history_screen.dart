import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/delivery_page_cursor.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/usecase/get_history_paginated_use_case.dart';
import 'package:zachranobed/features/food/presentation/model/food_allergen.dart';
import 'package:zachranobed/features/food/presentation/widget/food_allergens_bottom_sheet.dart';
import 'package:zachranobed/features/food/presentation/widget/meal_tile_factory.dart';

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
  static const double _paginationScrollThreshold = 200;

  final _useCase = GetIt.I<GetHistoryPaginatedUseCase>();
  final _scrollController = ScrollController();

  final List<SectionedListEntry<OfferedFood>> _items = [];

  /// Date of the last added item, used only to decide section header breaks.
  DateTime? _lastItemDate;

  /// Cursor for the next page, or null before the first load and once the last
  /// page has been reached.
  DeliveryPageCursor? _nextCursor;

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
    final currentPosition = _scrollController.position.pixels;
    final maxPosition = _scrollController.position.maxScrollExtent;
    if (_hasMore && currentPosition >= maxPosition - _paginationScrollThreshold) {
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
        _nextCursor = null;
      }
    });

    try {
      final user = HelperService.getCurrentUser(context);
      if (user == null) {
        _setError();
        return;
      }

      final page = await _useCase.invoke(
        user: user,
        startAfter: initial ? null : _nextCursor,
      );

      setState(() {
        _addItemsToEntries(page.items);
        _nextCursor = page.nextCursor;

        _isLoading = false;
        _hasMore = page.nextCursor != null;
      });

      // If the content is too short, automatically trigger the next load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_hasMore && _scrollController.hasClients && _scrollController.position.maxScrollExtent == 0) {
          _loadData();
        }
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
        actions: [
          UiIconButton.gradient(
            icon: Icons.info_outline,
            onPressed: () {
              final allergens = FoodAllergen.all(context);
              FoodAllergensBottomSheet.show(context, allergens, fullHeight: true);
            },
          ),
        ],
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

    final showManualDonationCard = HelperService.watchCurrentUser(context)?.manualDonationEnabled ?? false;
    final manualDonationCard = showManualDonationCard ? _buildManualDonationCard(context) : null;

    if (_items.isEmpty) {
      return _buildEmptyPage(manualDonationCard);
    }

    return _HistoryList(
      items: _items,
      leading: manualDonationCard,
      hasMore: _hasMore,
      onRefresh: _loadInitialData,
      controller: _scrollController,
    );
  }

  Widget _buildManualDonationCard(BuildContext context) {
    return UiNotificationTile(
      title: context.l10n.manualDonationCardTitle,
      description: context.l10n.manualDonationCardInHistoryDescription,
      actions: [
        UiPrimaryButton(
          text: context.l10n.manualDonationAddMealsAction,
          size: UiButtonSize.medium(fullWidth: true),
          onPressed: () async {
            final saved = await context.router.push(const AddMealsToHistoryRoute());
            if (saved == true) {
              _loadInitialData();
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyPage(Widget? manualDonationCard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (manualDonationCard != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: manualDonationCard,
          ),
        Expanded(
          child: InfoPage(
            image: ImageAssets.imageEmptyChef,
            title: context.l10n.donationsEmptyTitle,
            description: context.l10n.donationsEmptyDescription,
          ),
        ),
      ],
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

  /// Optional widget rendered as the first scrollable entry, so it scrolls away with the list.
  final Widget? leading;

  const _HistoryList({
    required this.items,
    required this.hasMore,
    required this.onRefresh,
    required this.controller,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <SectionedListEntry<OfferedFood>>[
      if (leading != null)
        SectionedListItemWidget<OfferedFood>(
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: leading!,
          ),
        ),
      ...items,
      if (hasMore)
        const SectionedListItemWidget<OfferedFood>(
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
    ];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SectionedListView<OfferedFood>.builder(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        entries: entries,
        itemBuilder: (context, item) => MealTileFactory.buildMealTile(context, item),
      ),
    );
  }
}
