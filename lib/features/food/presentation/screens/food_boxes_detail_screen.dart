import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_food_box_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/food_box_tile_stat.dart';

/// A screen that displays detailed food box statistics.
@RoutePage()
class FoodBoxesDetailScreen extends StatefulWidget {
  /// The user data to display statistics for.
  final UserData user;

  /// Creates a [FoodBoxesDetailScreen].
  const FoodBoxesDetailScreen({
    super.key,
    required this.user,
  });

  @override
  State<FoodBoxesDetailScreen> createState() => _FoodBoxesDetailScreenState();
}

class _FoodBoxesDetailScreenState extends State<FoodBoxesDetailScreen> {
  late final Stream<Iterable<FoodBoxStatistics>> _stream;

  @override
  void initState() {
    super.initState();
    final useCase = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
    _stream = useCase.invoke(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: _stream,
      builder: (context, snapshot) {
        return ScreenScaffold.universal(
          appBar: UiAppBar(title: context.l10n.overviewFoodBoxesHeaderTitle),
          child: _buildContent(context, snapshot),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AsyncSnapshot<Iterable<FoodBoxStatistics>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final statistics = snapshot.data!.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: statistics.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildTile(context, statistics[index]),
    );
  }

  Widget _buildTile(BuildContext context, FoodBoxStatistics stat) {
    return UiFoodBoxTile(
      title: stat.type.name,
      size: UiFoodBoxTileSize.full,
      totalLabel: context.l10n.overviewFoodBoxesTotalLabel(stat.totalQuantity),
      stats: FoodBoxTileStat.buildFullTileStats(context, widget.user, stat),
    );
  }
}
