import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card_list.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';

class OverviewScreen extends StatelessWidget {
  final _deliveryService = GetIt.I<DeliveryService>();

  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.overview),
        actions: [
          IconButton(
            onPressed: () {
              print('Bell pressed');
            },
            icon: const Icon(Icons.mark_email_unread_outlined),
          ),
          IconButton(
            onPressed: () {
              context.router.push(const MenuRoute());
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildInfoBanner(context),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            sliver: MultiSliver(
              children: [
                const CardList(),
                const SizedBox(height: GapSize.s),
                _buildDonatedFoodList(context),
                const SizedBox(height: GapSize.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    final deliveryConfirmed =
        context.watch<DeliveryNotifier>().deliveryConfirmed(context);

    if (user is Charity || !HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    if (user is Canteen) {
      return deliveryConfirmed
          ? _buildDeliveryConfirmedBanner(context, user)
          : _buildDonationCountdownBanner(context);
    }

    return const SliverToBoxAdapter(child: SizedBox());
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
        buttonText: context.l10n!.contactCarrier,
        buttonIcon: Icons.phone_outlined,
        onButtonPressed: () async =>
            await HelperService.makePhoneCall('123456789'),
      ),
    );
  }

  Widget _buildDonationCountdownBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: context.l10n!.youCanDonate,
        infoValue: const DonationCountdownTimer(),
        buttonText: context.l10n!.callACourier,
        buttonIcon: Icons.directions_car_filled_outlined,
        onButtonPressed: () async {
          await _callACourier(context);
        },
      ),
    );
  }

  Future<void> _callACourier(BuildContext context) async {
    await _deliveryService.updateDeliveryStatus(
      context.read<DeliveryNotifier>().delivery!.id,
      context.l10n!.deliveryConfirmedState,
    );
    if (context.mounted) {
      context
          .read<DeliveryNotifier>()
          .updateDeliveryState(context.l10n!.deliveryConfirmedState);
    }
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: context.l10n!.lastDonated,
      itemsLimit: 5,
    );
  }
}
