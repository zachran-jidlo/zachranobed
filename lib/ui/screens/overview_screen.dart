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
      body: CustomScrollView(
        slivers: [
          FutureBuilder<Widget>(
            future: _buildInfoBanner(context, user!),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  !snapshot.hasData) {
                return const SliverToBoxAdapter(child: SizedBox());
              }
              return snapshot.data!;
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
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

  Future<Widget> _buildInfoBanner(BuildContext context, UserData user) async {
    final deliveryNotifier = context.watch<DeliveryNotifier>();
    final canDonate = await HelperService.canDonate(context);

    if (user is! Canteen || !canDonate) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    if (deliveryNotifier.delivery?.state == DeliveryState.accepted ||
        deliveryNotifier.delivery?.state == DeliveryState.offered) {
      if (user.isCurrentTimeWithinPickupRange()) {
        return _buildDeliveryConfirmedBanner(context, user);
      } else {
        return const SliverToBoxAdapter(child: SizedBox());
      }
    } else {
      return _buildDonationCountdownBanner(context);
    }
  }

  Widget _buildDeliveryConfirmedBanner(BuildContext context, Canteen user) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: context.l10n!.courierWillCome,
        infoValue: Text(
          '${user.pickUpFrom} a ${user.pickUpWithin}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s,
            color: ZOColors.onPrimaryLight,
          ),
        ),
        backgroundColor: ZOColors.successLight,
      ),
    );
  }

  Widget _buildDonationCountdownBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: context.l10n!.youCanDonate,
        infoValue: const DonationCountdownTimer(),
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
        backgroundColor: ZOColors.successLight,
      ),
    );
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: context.l10n!.lastDonated,
      itemsLimit: 5,
    );
  }
}
