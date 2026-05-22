import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/checkup/food_boxes_checkup_tile_delayed.dart';
import 'package:zachranobed/features/food/presentation/widget/checkup/food_boxes_checkup_tile_mismatch.dart';
import 'package:zachranobed/features/food/presentation/widget/checkup/food_boxes_checkup_tile_verified.dart';
import 'package:zachranobed/features/food/presentation/widget/food_box_tile_stat_factory.dart';

/// A section widget that displays food box statistics on the overview screen.
///
/// Shows returnable box types with their quantities. Uses a full-size tile
/// when there is only one box type, and small tiles in a grid when there
/// are multiple types.
///
/// Also displays checkup-related banners based on the current checkup state.
class FoodBoxesOverviewSection extends StatefulWidget {
  /// The user data to display statistics for.
  final UserData user;

  /// The current state of the food boxes checkup.
  final FoodBoxesCheckupState checkupState;

  /// Creates a [FoodBoxesOverviewSection] widget.
  const FoodBoxesOverviewSection({
    super.key,
    required this.user,
    required this.checkupState,
  });

  @override
  State<FoodBoxesOverviewSection> createState() => _FoodBoxesOverviewSectionState();
}

class _FoodBoxesOverviewSectionState extends State<FoodBoxesOverviewSection> {
  late Stream<Iterable<FoodBoxStatistics>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _createStream();
  }

  @override
  void didUpdateWidget(FoodBoxesOverviewSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _stream = _createStream();
    }
  }

  Stream<Iterable<FoodBoxStatistics>> _createStream() {
    final useCase = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
    return useCase.invoke(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final statistics = snapshot.data!.toList();

        if (statistics.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 8.0,
              ),
              child: _buildHeader(context),
            ),
            _buildCheckupBanner(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildContent(context, statistics),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCheckupBanner(BuildContext context) {
    final state = widget.checkupState;
    Widget? banner;
    if (state is FoodBoxesCheckupDelayed) {
      banner = FoodBoxesCheckupTileCheckDelayed(
        remainingDuration: state.duration,
        onPressed: () {
          context.router.push(
            FoodBoxesDetailRoute(
              user: widget.user,
              isCheckupMode: true,
            ),
          );
        },
      );
    } else if (state is FoodBoxesCheckupMismatch) {
      banner = FoodBoxesCheckupTileMismatch();
    } else if (state is FoodBoxesCheckupAllGood && state.isVerified) {
      banner = const FoodBoxesCheckupTileVerified();
    }

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: banner,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.overviewFoodBoxesHeaderTitle,
            style: context.textStyles.titleMedium,
          ),
        ),
        UiTextButton(
          text: context.l10n.overviewFoodBoxesShowAllAction,
          onPressed: () {
            context.router.push(FoodBoxesDetailRoute(user: widget.user));
          },
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<FoodBoxStatistics> statistics,
  ) {
    if (statistics.length == 1) {
      return _buildFullTile(context, statistics.first);
    }

    return _buildSmallTilesGrid(context, statistics);
  }

  Widget _buildFullTile(BuildContext context, FoodBoxStatistics stat) {
    return UiFoodBoxTile(
      title: stat.type.name,
      size: UiFoodBoxTileSize.full,
      totalLabel: context.l10n.overviewFoodBoxesTotalLabel(stat.totalQuantity),
      stats: FoodBoxTileStatFactory.buildFullTileStats(context, widget.user, stat),
    );
  }

  Widget _buildSmallTilesGrid(
    BuildContext context,
    List<FoodBoxStatistics> statistics,
  ) {
    final chunks = statistics.chunked(2).toList();

    return Column(
      spacing: 8.0,
      children: chunks.map((chunk) {
        final items = chunk.toList();
        return Row(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSmallTile(context, items[0]),
            ),
            Expanded(
              child: items.length > 1 ? _buildSmallTile(context, items[1]) : const SizedBox.shrink(),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSmallTile(BuildContext context, FoodBoxStatistics stat) {
    final value = switch (widget.user) {
      Canteen() => stat.availableQuantityAtCanteen,
      Charity() => stat.availableQuantityAtCharity,
    };

    return UiFoodBoxTile(
      title: stat.type.name,
      size: UiFoodBoxTileSize.small,
      stats: [
        UiFoodBoxTileStat(
          value: value,
          label: context.l10n.overviewFoodBoxesAvailableLabel,
        ),
      ],
    );
  }
}
