import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/app/presentation/widget/canteen_donation_status_card.dart';
import 'package:zachranobed/app/presentation/widget/charity_donation_status_card.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/charity.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_welcome_tile.dart';
import 'package:zachranobed/app/presentation/widget/food_boxes_overview_section.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> with LifecycleWatcher {
  FoodBoxesCheckupState _boxesCheckupState = FoodBoxesCheckupAllGood(isVerified: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshBoxesCheckupState();
  }

  @override
  void didUpdateWidget(covariant OverviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshBoxesCheckupState();
  }

  @override
  void onResume() {
    super.onResume();
    _refreshBoxesCheckupState();
  }

  @override
  Widget build(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    if (user == null) {
      return const SizedBox();
    }
    return ScreenScaffold.universalBuilder(
      appBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UiWelcomeTile(
          entityName: user.establishmentName,
          onPressed: () {
              context.router.push(const ProfileRoute());
          },
        ),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            _buildDonationStatusCard(context, user),
            const SizedBox(height: 24.0),
            FoodBoxesOverviewSection(user: user),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  /// Refreshes the state of the food boxes checkup.
  void _refreshBoxesCheckupState() {
    setState(() {
      final user = HelperService.getCurrentUser(context);
      if (user != null) {
        _boxesCheckupState = user.getFoodBoxesCheckup(user.activePair).getState();
      }
    });
  }

  Widget _buildDonationStatusCard(BuildContext context, UserData user) {
    final delivery = context.watch<DeliveryNotifier>().delivery;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: switch (user) {
        Canteen() => CanteenDonationStatusCard(
            canteen: user,
            delivery: delivery,
            onChangePairPressed: _onChangePairPressed,
            onAcceptDeliveryPressed: () => _onAcceptDeliveryPressed(user),
            onOfferFoodPressed: _onOfferFoodPressed,
            onCountdownTimeout: _onDeliveryConfirmationTimeout,
          ),
        Charity() => CharityDonationStatusCard(
            charity: user,
            delivery: delivery,
            onChangePairPressed: _onChangePairPressed,
          ),
        _ => const SizedBox(),
      },
    );
  }

  void _onChangePairPressed() async {
    await context.router.push(const ChangeActivePairRoute());
    _refreshBoxesCheckupState();
  }

  void _onAcceptDeliveryPressed(UserData user) async {
    // TODO: How to process this?
    // final foodBoxesCheckupState = user.getFoodBoxesCheckup(user.activePair).getState();
    // if (foodBoxesCheckupState is FoodBoxesCheckupCheckNeeded && !foodBoxesCheckupState.isDelayAvailable) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => ZODialog(
    //       criticalConfirmStyle: true,
    //       title: context.l10n.foodBoxesCheckupDialogTitle,
    //       content: context.l10n.foodBoxesCheckupDialogContent,
    //       confirmText: context.l10n.foodBoxesCheckupDialogConfirmAction,
    //       cancelText: context.l10n.commonCancel,
    //       onConfirmPressed: () {
    //         context.router.maybePop();
    //         _setBoxesCheckupInProgress();
    //       },
    //       onCancelPressed: () => context.router.maybePop(),
    //     ),
    //   );
    //   return;
    // }
    context.read<DeliveryNotifier>().updateDeliveryState(DeliveryState.accepted);
  }

  void _onOfferFoodPressed() {
    context.router.push(const OfferFoodInitialRoute());
  }

  void _onDeliveryConfirmationTimeout() {
    context.read<DeliveryNotifier>().refreshDelivery();
  }
}
