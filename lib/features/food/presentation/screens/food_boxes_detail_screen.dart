import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/content_with_loading.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_tile.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/verify_food_boxes_checkup_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/food_box_tile_stat_factory.dart';

/// A screen that displays detailed food box statistics.
///
/// In checkup mode, displays a notification tile and action buttons for
/// verifying or reporting mismatch in food box counts.
@RoutePage()
class FoodBoxesDetailScreen extends StatefulWidget {
  /// The user data to display statistics for.
  final UserData user;

  /// Whether the screen is in checkup mode.
  ///
  /// When true, shows checkup UI with action buttons.
  final bool isCheckupMode;

  /// Creates a [FoodBoxesDetailScreen].
  const FoodBoxesDetailScreen({
    super.key,
    required this.user,
    this.isCheckupMode = false,
  });

  @override
  State<FoodBoxesDetailScreen> createState() => _FoodBoxesDetailScreenState();
}

class _FoodBoxesDetailScreenState extends State<FoodBoxesDetailScreen> {
  late final Stream<Iterable<FoodBoxStatistics>> _stream;
  late final VerifyFoodBoxesCheckupUseCase _verifyCheckup;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final observeStatistics = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
    _stream = observeStatistics.invoke(widget.user);
    _verifyCheckup = GetIt.I<VerifyFoodBoxesCheckupUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: _stream,
      builder: (context, snapshot) {
        return ScreenScaffold.universal(
          appBar: UiAppBar(title: context.l10n.overviewFoodBoxesHeaderTitle),
          child: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<Iterable<FoodBoxStatistics>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return const LoadingPage();
    }

    final statistics = snapshot.data!.toList();

    return ContentWithLoading(
      isLoading: _isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildContent(context, statistics)),
          if (widget.isCheckupMode) _buildCheckupActions(context, statistics),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<FoodBoxStatistics> statistics,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.isCheckupMode)
            UiNotificationTile(
              icon: Icons.warning_rounded,
              title: context.l10n.foodBoxesCheckupNeededCardTitle,
              description: context.l10n.foodBoxesCheckupInProgressDescription,
            ),
          ...statistics.map((stat) => _buildTile(context, stat)),
        ],
      ),
    );
  }

  Widget _buildCheckupActions(
    BuildContext context,
    List<FoodBoxStatistics> statistics,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        spacing: 8.0,
        children: [
          Expanded(
            child: UiOutlineButton(
              text: context.l10n.foodBoxesCheckupInProgressMismatchesAction,
              size: UiButtonSize.medium(fullWidth: true),
              onPressed: () {
                context.router.push(
                  FoodBoxesCheckupMismatchRoute(
                    user: widget.user,
                    statistics: statistics,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: UiPrimaryButton(
              text: context.l10n.foodBoxesCheckupInProgressMatchesAction,
              size: UiButtonSize.medium(fullWidth: true),
              onPressed: () {
                _withLoading(
                  context: context,
                  action: () => _verifyCheckup.invoke(widget.user),
                  onSuccess: () {
                    UiTemporarySnackBar.show(context, message: context.l10n.foodBoxesCheckupSuccessMessage);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, FoodBoxStatistics stat) {
    if (widget.isCheckupMode) {
      return UiFoodBoxTile(
        title: stat.type.name,
        size: UiFoodBoxTileSize.full,
        totalLabel: context.l10n.overviewFoodBoxesTotalLabel(stat.totalQuantity),
        stats: FoodBoxTileStatFactory.buildFullTileStats(context, widget.user, stat),
        isSelected: true,
        onTheWay: FoodBoxTileStatFactory.buildOnTheWay(widget.user, stat),
      );
    } else {
      return UiFoodBoxTile(
        title: stat.type.name,
        size: UiFoodBoxTileSize.full,
        totalLabel: context.l10n.overviewFoodBoxesTotalLabel(stat.totalQuantity),
        stats: FoodBoxTileStatFactory.buildFullTileStats(context, widget.user, stat, showOnTheWay: true),
      );
    }
  }

  /// Executes an [action] with a loading indicator.
  ///
  /// If the [action] is successful, it reloads the user information and refreshes the state. If the action fails,
  /// it shows an error message.
  void _withLoading({
    required BuildContext context,
    required Future<bool> Function() action,
    Function()? onSuccess,
  }) async {
    setState(() {
      _isLoading = true;
    });

    final success = await action();
    if (context.mounted) {
      if (success) {
        await HelperService.loadUserInfo(context);
        if (context.mounted) {
          onSuccess?.call();
          context.router.maybePop();
        }
      } else {
        UiTemporarySnackBar.showError(context, message: context.l10n.foodBoxesCheckupErrorMessage);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
