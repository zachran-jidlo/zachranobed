import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/charity.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/app_bar.dart';
import 'package:zachranobed/common/presentation/widget/button.dart';
import 'package:zachranobed/common/presentation/widget/card_row.dart';
import 'package:zachranobed/common/presentation/widget/delivery_info_banner.dart';
import 'package:zachranobed/common/presentation/widget/indicator.dart';
import 'package:zachranobed/common/presentation/widget/new_offer_floating_button.dart';
import 'package:zachranobed/common/presentation/widget/new_shipping_of_boxes_floating_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/features/food/presentation/widget/box_summary.dart';
import 'package:zachranobed/features/food/presentation/widget/card_list.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> with LifecycleWatcher {
  final GlobalKey _boxSummaryKey = GlobalKey();
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
    return ScreenScaffold.universalBuilder(
      appBar: ZOAppBar(
        title: context.l10n.overview,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const ProfileRoute());
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    return Scaffold(
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
                _buildActivePair(context),
                CardList(user: user),
                const SizedBox(height: GapSize.m),
                BoxSummary(
                  key: _boxSummaryKey,
                  user: user,
                  state: _boxesCheckupState,
                  refreshState: _refreshBoxesCheckupState,
                  setInProgress: _setBoxesCheckupInProgress,
                ),
                const SizedBox(height: GapSize.m),
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

    // Delay to ensure layout is complete before scrolling to the box summary
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boxSummaryContext = _boxSummaryKey.currentContext;
      if (boxSummaryContext != null) {
        Scrollable.ensureVisible(
          boxSummaryContext,
          duration: const Duration(milliseconds: 250),
        );
      }
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

    return user is Canteen ? NewOfferFloatingButton() : const NewShippingOfBoxesFloatingButton();
  }

  Widget _buildActivePair(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    switch (user) {
      case Charity():
        return Column(
          children: [
            CardRow(
              label: context.l10n.activePairCardCanteenLabel,
              title: user.activePair.donorEstablishmentName,
              action: (context) {
                if (!user.hasMultiplePairs) {
                  return const SizedBox();
                }
                return Indicator(
                  isVisible: user.isAnyNonActiveCheckupNeeded,
                  child: ZOButton(
                    text: context.l10n.activePairCardChangeAction,
                    type: ZOButtonType.secondary,
                    minimumSize: ZOButtonSize.tiny(),
                    onPressed: () async {
                      await context.router.push(const ChangeActivePairRoute());
                      _refreshBoxesCheckupState();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: GapSize.xs),
          ],
        );
      case Canteen():
        return Column(
          children: [
            CardRow(
              label: context.l10n.activePairCardCharityLabel,
              title: user.activePair.recipientEstablishmentName,
              action: (context) {
                if (!user.hasMultiplePairs) {
                  return const SizedBox();
                }
                return Indicator(
                  isVisible: user.isAnyNonActiveCheckupNeeded,
                  child: ZOButton(
                    text: context.l10n.activePairCardChangeAction,
                    type: ZOButtonType.secondary,
                    minimumSize: ZOButtonSize.tiny(),
                    onPressed: () async {
                      await context.router.push(const ChangeActivePairRoute());
                      _refreshBoxesCheckupState();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: GapSize.xs),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
