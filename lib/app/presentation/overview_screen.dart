import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/app/presentation/widget/canteen_donation_status_card.dart';
import 'package:zachranobed/app/presentation/widget/charity_donation_status_card.dart';
import 'package:zachranobed/app/presentation/widget/food_boxes_overview_section.dart';
import 'package:zachranobed/app/presentation/widget/messages_section.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/ui_welcome_tile.dart';

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
            MessagesSection(
              user: user,
              checkupState: _boxesCheckupState,
              refreshCheckupState: _refreshBoxesCheckupState,
            ),
            const SizedBox(height: 8.0),
            _buildDonationStatusCard(context, user),
            const SizedBox(height: 24.0),
            FoodBoxesOverviewSection(
              user: user,
              checkupState: _boxesCheckupState,
            ),
            ..._buildNewBoxDeliveryButton(context, user),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
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
            onOfferFoodPressed: () => _onOfferFoodPressed(user),
            onCountdownTimeout: _onDeliveryConfirmationTimeout,
            onDeliveryDetailPressed: _onDeliveryDetailPressed,
          ),
        Charity() => CharityDonationStatusCard(
            charity: user,
            delivery: delivery,
            onChangePairPressed: _onChangePairPressed,
            onDeliveryDetailPressed: _onDeliveryDetailPressed,
          ),
      },
    );
  }

  List<Widget> _buildNewBoxDeliveryButton(BuildContext context, UserData user) {
    if (user is! Charity || !user.activePair.usesReturnableFoodBoxes) {
      return [];
    }

    return [
      const SizedBox(height: 16.0),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: UiOutlineButton(
            size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
            text: context.l10n.overviewCreateBoxDeliveryAction,
            onPressed: () => _onReturnBoxesPressed(user),
          ),
        ),
      ),
    ];
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

  void _onChangePairPressed() async {
    await context.router.push(const ChangeActivePairRoute());
    _refreshBoxesCheckupState();
  }

  void _onAcceptDeliveryPressed(UserData user) async {
    if (_showCheckupNeededDialog(user)) {
      return;
    }
    context.read<DeliveryNotifier>().updateDeliveryState(DeliveryState.accepted);
  }

  void _onOfferFoodPressed(UserData user) {
    if (_showCheckupNeededDialog(user)) {
      return;
    }
    context.router.push(const OfferFoodInitialRoute());
  }

  void _onReturnBoxesPressed(UserData user) {
    if (_showCheckupNeededDialog(user)) {
      return;
    }
    context.router.push(const OrderShippingOfBoxesRoute());
  }

  void _onDeliveryDetailPressed(String id) {
    context.pushRoute(DeliveryDetailRoute(deliveryId: id));
  }

  void _onDeliveryConfirmationTimeout() {
    context.read<DeliveryNotifier>().refreshDelivery();
  }

  bool _showCheckupNeededDialog(UserData user) {
    final checkupState = user.getFoodBoxesCheckup(user.activePair).getState();
    if (checkupState is FoodBoxesCheckupCheckNeeded && !checkupState.isDelayAvailable) {
      final (title, content) = switch (user) {
        Canteen() => (
            context.l10n.foodBoxesCheckupDialogCanteenTitle,
            context.l10n.foodBoxesCheckupDialogCanteenContent,
          ),
        Charity() => (
            context.l10n.foodBoxesCheckupDialogCharityTitle,
            context.l10n.foodBoxesCheckupDialogCharityContent,
          ),
      };

      showDialog(
        context: context,
        builder: (context) => UiDialog(
          title: title,
          content: content,
          actions: [
            UiTextButton(
              text: context.l10n.commonClose,
              onPressed: () => context.maybePop(),
            ),
            UiPrimaryButton(
              text: context.l10n.foodBoxesCheckupDialogConfirmAction,
              onPressed: () async {
                await context.maybePop();
                if (context.mounted) {
                  context.router.push(
                    FoodBoxesDetailRoute(
                      user: user,
                      isCheckupMode: true,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
      return true;
    }

    return false;
  }
}
