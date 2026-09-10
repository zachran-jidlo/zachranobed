import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:get_it/get_it.dart';
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
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_welcome_tile.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';
import 'package:zachranobed/features/banners/domain/usecase/dismiss_banner_use_case.dart';
import 'package:zachranobed/features/banners/domain/usecase/observe_active_banners_use_case.dart';

class OverviewScreen extends StatefulWidget {
  /// Called when the user chooses to record a donation from the manual donation
  /// entry card, switching to the History tab.
  final VoidCallback onNavigateToHistoryPressed;

  const OverviewScreen({super.key, required this.onNavigateToHistoryPressed});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> with LifecycleWatcher {
  final _observeActiveBanners = GetIt.I<ObserveActiveBannersUseCase>();
  final _dismissBanner = GetIt.I<DismissBannerUseCase>();

  FoodBoxesCheckupState _boxesCheckupState = FoodBoxesCheckupAllGood(isVerified: false, isVerifiedByUser: false);
  Stream<List<Banner>>? _bannersStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshBoxesCheckupState();
    _ensureBannersStream();
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
        child: Semantics(
          identifier: 'overview_welcome_tile',
          child: UiWelcomeTile(
            entityName: user.establishmentName,
            onPressed: () {
              context.router.push(const ProfileRoute());
            },
          ),
        ),
      ),
      builder: (context) => Semantics(
        identifier: 'overview_screen',
        container: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<Banner>>(
                stream: _bannersStream,
                builder: (context, snapshot) => MessagesSection(
                  user: user,
                  banners: snapshot.data ?? const [],
                  onBannerDismiss: _onBannerDismiss,
                  checkupState: _boxesCheckupState,
                  refreshCheckupState: _refreshBoxesCheckupState,
                  onNavigateToHistoryPressed: widget.onNavigateToHistoryPressed,
                ),
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
            onConfirmPickupPressed: _onConfirmPickupPressed,
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

  /// Creates the banners stream once the user is available. The logged-in
  /// entity is stable for this screen's lifetime (logout recreates the screen),
  /// so the stream is built once.
  void _ensureBannersStream() {
    if (_bannersStream != null) {
      return;
    }
    final user = HelperService.getCurrentUser(context);
    if (user != null) {
      _bannersStream = _observeActiveBanners.invoke(user: user);
    }
  }

  void _onBannerDismiss(String id) {
    _dismissBanner.invoke(id);
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

  void _onConfirmPickupPressed() {
    context.read<DeliveryNotifier>().confirmPickup();
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
              onPressed: () => context.router.maybePop(),
            ),
            UiPrimaryButton(
              text: context.l10n.foodBoxesCheckupDialogConfirmAction,
              onPressed: () async {
                await context.router.maybePop();
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
