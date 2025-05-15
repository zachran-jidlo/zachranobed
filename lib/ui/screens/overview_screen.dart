import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/lifecycle/lifecycle_watcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_summary.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/card_list.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/food_boxes_checkup_state.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/card_row.dart';
import 'package:zachranobed/ui/widgets/delivery_info_banner.dart';
import 'package:zachranobed/ui/widgets/indicator.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';
import 'package:zachranobed/ui/widgets/new_shipping_of_boxes_floating_button.dart';
import 'package:zachranobed/ui/widgets/notification_icon_button.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> with LifecycleWatcher {
  FoodBoxesCheckupState _boxesCheckupState = FoodBoxesCheckupAllGood(isVerified: false);

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.overview),
        actions: [
          NotificationIconButton(
            user: user,
            onPressed: () {
              context.router.push(const NotificationsRoute());
            },
          ),
          IconButton(
            onPressed: () {
              context.router.push(const MenuRoute());
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: _floatingActionButton(context),
      body: CustomScrollView(
        slivers: [
          DeliveryInfoBanner(
            user: user!,
            showFoodBoxesCheckup: _setBoxesCheckupInProgress,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: WidgetStyle.padding,
              right: WidgetStyle.padding,
              bottom: WidgetStyle.overviewBottomPadding,
            ),
            sliver: MultiSliver(
              children: [
                _buildActiveCanteen(context),
                CardList(user: user),
                const SizedBox(height: GapSize.m),
                BoxSummary(
                  user: user,
                  state: _boxesCheckupState,
                  refreshState: _refreshBoxesCheckupState,
                  setInProgress: _setBoxesCheckupInProgress,
                ),
                const SizedBox(height: GapSize.m),
                _buildDonatedFoodList(context),
                const SizedBox(height: GapSize.xs),
              ],
            ),
          ),
        ],
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

  /// Sets the state of the food boxes checkup to in-progress.
  void _setBoxesCheckupInProgress() {
    setState(() {
      _boxesCheckupState = FoodBoxesCheckupCheckInProgress();
    });
  }

  Widget _floatingActionButton(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return const SizedBox();
    }

    // When food boxes checkup is needed and cannot be delayed floating action button should not be accessible
    final foodBoxesCheckupState = user.getFoodBoxesCheckup(user.activePair).getState();
    if (foodBoxesCheckupState is FoodBoxesCheckupCheckNeeded && !foodBoxesCheckupState.isDelayAvailable) {
      return const SizedBox();
    }

    return user is Canteen ? const NewOfferFloatingButton() : const NewShippingOfBoxesFloatingButton();
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: context.l10n!.lastDonated,
      itemsLimit: 5,
      alwaysShowTitle: false,
    );
  }

  Widget _buildActiveCanteen(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    if (user is! Charity) {
      return const SizedBox();
    }
    return Column(
      children: [
        CardRow(
          label: context.l10n!.activePairCardCanteenLabel,
          title: user.activePair.donorEstablishmentName,
          action: (context) {
            if (!user.hasMultiplePairs) {
              return const SizedBox();
            }
            return Indicator(
              isVisible: user.isAnyNonActiveCheckupNeeded,
              child: ZOButton(
                text: context.l10n!.activePairCardChangeAction,
                type: ZOButtonType.secondary,
                minimumSize: ZOButtonSize.tiny(),
                onPressed: () {
                  context.router.push(const ChangeActivePairRoute());
                },
              ),
            );
          },
        ),
        const SizedBox(height: GapSize.xs),
      ],
    );
  }
}
