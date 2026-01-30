import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/other/content_with_loading.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_food_box_tile.dart';
import 'package:zachranobed/common/presentation/widget/ui_notification_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/report_food_boxes_mismatch_use_case.dart';
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
  late final ReportFoodBoxesMismatchUseCase _reportMismatch;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final observeStatistics = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
    _stream = observeStatistics.invoke(widget.user);
    _verifyCheckup = GetIt.I<VerifyFoodBoxesCheckupUseCase>();
    _reportMismatch = GetIt.I<ReportFoodBoxesMismatchUseCase>();
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
      return const LoadingPage();
    }

    final statistics = snapshot.data!.toList();

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
          if (widget.isCheckupMode)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildCheckupActions(context),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckupActions(BuildContext context) {
    return ContentWithLoading(
      isLoading: _isLoading,
      child: Row(
        spacing: 8.0,
        children: [
          Expanded(
            child: UiOutlineButton(
              text: context.l10n.foodBoxesCheckupInProgressMismatchesAction,
              size: UiButtonSize.medium(fullWidth: true),
              onPressed: () {
                _withLoading(
                  context: context,
                  action: () => _reportMismatch.invoke(widget.user),
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
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      ZOTemporarySnackBar(message: context.l10n.foodBoxesCheckupSuccessMessage),
                    );
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
    return UiFoodBoxTile(
      title: stat.type.name,
      size: UiFoodBoxTileSize.full,
      totalLabel: context.l10n.overviewFoodBoxesTotalLabel(stat.totalQuantity),
      stats: FoodBoxTileStatFactory.buildFullTileStats(context, widget.user, stat),
      isSelected: widget.isCheckupMode,
    );
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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(message: context.l10n.foodBoxesCheckupErrorMessage),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
