import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_data_table.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/card_list.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';
import 'package:zachranobed/ui/widgets/new_shipping_of_boxes_floating_button.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.overview),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const MenuRoute());
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: HelperService.getCurrentUser(context) is Canteen
          ? NewOfferFloatingButton()
          : const NewShippingOfBoxesFloatingButton(),
      body: CustomScrollView(
        slivers: [
          _buildInfoBanner(context, user!),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: WidgetStyle.padding,
              right: WidgetStyle.padding,
              bottom: WidgetStyle.overviewBottomPadding,
            ),
            sliver: MultiSliver(
              children: [
                CardList(user: user),
                const SizedBox(height: GapSize.m),
                BoxDataTable(user: user),
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

  Widget _buildInfoBanner(BuildContext context, UserData user) {
    final delivery = context.watch<DeliveryNotifier>().delivery;
    if (user is! Canteen || !HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return delivery?.state == DeliveryState.accepted ||
            delivery?.state == DeliveryState.offered
        ? _buildDeliveryConfirmedBanner(context, user)
        : _buildDonationCountdownBanner(context);
  }

  Widget _buildDeliveryConfirmedBanner(BuildContext context, Canteen user) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        backgroundColor: ZOColors.successLight,
        message: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: '${context.l10n!.courierWillCome} ',
            style: const TextStyle(
              color: ZOColors.onPrimaryLight,
              fontSize: FontSize.s,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: '${user.pickUpFrom} a ${user.pickUpWithin}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationCountdownBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        backgroundColor: ZOColors.successLight,
        message: const DonationCountdownTimer(),
        button: ZOButton(
          text: context.l10n!.callACourier,
          fullWidth: false,
          type: ZOButtonType.success,
          onPressed: () {
            context
                .read<DeliveryNotifier>()
                .updateDeliveryState(DeliveryState.accepted);
          },
        ),
      ),
    );
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: context.l10n!.lastDonated,
      itemsLimit: 5,
      alwaysShowTitle: false,
    );
  }
}
