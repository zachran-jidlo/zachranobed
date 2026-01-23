import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/dto/food_box_type_dto.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/charity.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/ui_food_box_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';

/// A section widget that displays food box statistics on the overview screen.
///
/// Shows returnable box types with their quantities. Uses a full-size tile
/// when there is only one box type, and small tiles in a grid when there
/// are multiple types.
class FoodBoxesOverviewSection extends StatefulWidget {
  /// The user data to display statistics for.
  final UserData user;

  /// Creates a [FoodBoxesOverviewSection] widget.
  const FoodBoxesOverviewSection({
    super.key,
    required this.user,
  });

  @override
  State<FoodBoxesOverviewSection> createState() => _FoodBoxesOverviewSectionState();
}

class _FoodBoxesOverviewSectionState extends State<FoodBoxesOverviewSection> {
  late final ObserveFoodBoxStatisticsUseCase _useCase;

  @override
  void initState() {
    super.initState();
    _useCase = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: _useCase.invoke(widget.user),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final statistics = snapshot.data!.where((stat) => stat.type.id != FoodBoxTypeDto.idDisposable).toList();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildContent(context, statistics),
            ),
          ],
        );
      },
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
            // TODO: Navigate to food box statistics detail screen
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
      stats: _buildFullTileStats(context, stat),
    );
  }

  List<UiFoodBoxTileStat> _buildFullTileStats(
    BuildContext context,
    FoodBoxStatistics stat,
  ) {
    switch (widget.user) {
      case Canteen():
        return [
          UiFoodBoxTileStat(
            value: stat.quantityAtCanteen,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          UiFoodBoxTileStat(
            value: stat.quantityAtCharity,
            label: context.l10n.charity,
          ),
        ];
      case Charity():
        return [
          UiFoodBoxTileStat(
            value: stat.quantityAtCharity,
            label: context.l10n.overviewFoodBoxesAvailableLabel,
          ),
          UiFoodBoxTileStat(
            value: stat.quantityAtCanteen,
            label: context.l10n.canteen,
          ),
        ];
      default:
        return [];
    }
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
      Canteen() => stat.quantityAtCanteen,
      Charity() => stat.quantityAtCharity,
      _ => 0,
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
