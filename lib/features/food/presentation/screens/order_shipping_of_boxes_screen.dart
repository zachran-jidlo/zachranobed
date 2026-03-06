import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_box_counter_tile.dart';
import 'package:zachranobed/common/presentation/widget/form/ui_counter_field.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/usecase/create_box_delivery_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/verify_available_box_count_use_case.dart';

/// A screen that allows charity users to order shipping of food boxes
/// back to the canteen.
///
/// Displays a list of available box types with counters, allowing users to
/// specify how many boxes of each type they want to ship. Shows an empty state
/// when no boxes are available at the charity.
@RoutePage()
class OrderShippingOfBoxesScreen extends StatefulWidget {
  const OrderShippingOfBoxesScreen({super.key});

  @override
  State<OrderShippingOfBoxesScreen> createState() => _OrderShippingOfBoxesScreenState();
}

class _OrderShippingOfBoxesScreenState extends State<OrderShippingOfBoxesScreen> {
  final _observeFoodBoxStatistics = GetIt.I<ObserveFoodBoxStatisticsUseCase>();
  final _verifyAvailableBoxCount = GetIt.I<VerifyAvailableBoxCountUseCase>();
  final _createBoxDelivery = GetIt.I<CreateBoxDeliveryUseCase>();

  final Map<String, int> _boxesQuantity = {};

  late Future<Iterable<FoodBoxStatistics>> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  /// Loads food box statistics.
  void _loadStatistics() {
    setState(() {
      final user = HelperService.getCurrentUser(context)!;
      _statisticsFuture = _observeFoodBoxStatistics.invoke(user).first;
    });
  }

  void _showCancelConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.cancelShippingOfBoxes,
        content: context.l10n.cancelShippingOfBoxesDialogContent,
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

    if (mounted && confirmed == true) {
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(title: context.l10n.shippingOfBoxesToCanteen),
      builder: (context) {
        return FutureBuilder(
          future: _statisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }
            if (snapshot.hasError || snapshot.data == null) {
              return ErrorPage(onRetryPressed: _loadStatistics);
            }
            final availableBoxes = snapshot.requireData.where((s) => s.availableQuantityAtCharity > 0);
            if (availableBoxes.isEmpty) {
              return _buildEmptyPage();
            }
            return _buildContent(context, availableBoxes);
          },
        );
      },
    );
  }

  Widget _buildEmptyPage() {
    return InfoPage(
      image: ImageAssets.imageEmptyBox,
      title: context.l10n.shippingOfBoxesEmptyTitle,
      description: context.l10n.shippingOfBoxesEmptyDescription,
      actions: [
        UiPrimaryButton(
          size: UiButtonSize.medium(fullWidth: true),
          text: context.l10n.shippingOfBoxesEmptyAction,
          onPressed: () => context.router.maybePop(),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    Iterable<FoodBoxStatistics> availableBoxes,
  ) {
    return PopScope(
      canPop: _boxesQuantity.values.none((value) => value > 0),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showCancelConfirmationDialog();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildForm(context, availableBoxes),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    Iterable<FoodBoxStatistics> availableBoxes,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 24.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.shippingOfBoxesDescription,
            style: context.textStyles.bodyLarge,
          ),
          ...availableBoxes.map((value) {
            return UiBoxCounterTile(
              title: value.type.name,
              subtitle: context.l10n.totalCountOfBoxes(value.availableQuantityAtCharity),
              counterField: UiCounterField(
                label: context.l10n.numberOfBoxes,
                value: _boxesQuantity[value.type.id] ?? 0,
                maxValue: value.availableQuantityAtCharity,
                onChanged: (count) {
                  setState(() {
                    _boxesQuantity[value.type.id] = count;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        spacing: 16.0,
        direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
        children: [
          UiPrimaryButton(
            text: context.l10n.orderShipping,
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            onPressed: _onConfirmationButtonPressed,
          ),
        ],
      ),
    );
  }

  void _onConfirmationButtonPressed() async {
    final user = HelperService.getCurrentUser(context);
    if (user == null || user is! Charity) {
      return;
    }

    if (_boxesQuantity.values.every((quantity) => quantity == 0)) {
      if (mounted) {
        UiTemporarySnackBar.show(context, message: context.l10n.shippingOfBoxesEmptyFormMessage);
      }
    } else {
      UiDialog.showLoadingDialog(context);

      final available = await _verifyAvailableBoxCount.invoke(
        user: user,
        requiredBoxes: _boxesQuantity,
      );

      if (!available) {
        if (mounted) {
          context.router.pop();
          UiTemporarySnackBar.showError(context, message: context.l10n.boxCountError);
        }

        return;
      }

      final isSuccess = await _createBoxDelivery.invoke(
        charity: user,
        boxesQuantity: _boxesQuantity,
      );

      if (mounted) {
        context.router.pop();
        context.router.replace(
          ThankYouRoute(
            isSuccess: isSuccess,
            message: context.l10n.shippingOrderConfirmation,
          ),
        );
      }
    }
  }
}
