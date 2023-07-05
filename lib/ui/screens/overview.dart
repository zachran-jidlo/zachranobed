import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/delivery_api_service.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZOStrings.overview),
        actions: [
          IconButton(
            onPressed: () {
              print('Bell pressed');
            },
            icon: const Icon(Icons.mark_email_unread_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteManager.menu);
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
              horizontal: WidgetStyle.horizontalPadding,
            ),
            sliver: MultiSliver(
              children: [
                _buildCards(context),
                const SizedBox(height: 24.0),
                _buildDonatedFoodList(context),
                const SizedBox(height: 15.0),
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
        context.watch<DeliveryNotifier>().deliveryConfirmed();

    if (!HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return deliveryConfirmed
        ? SliverToBoxAdapter(
            child: InfoBanner(
              infoText: ZOStrings.courierWillCome,
              infoValue: Text(
                '${user!.pickUpFrom} a ${user.pickUpWithin}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: ZOColors.onPrimaryLight,
                ),
              ),
              buttonText: ZOStrings.contactCarrier,
              buttonIcon: Icons.phone_outlined,
              onButtonPressed: () async =>
                  await HelperService.makePhoneCall('123456789'),
            ),
          )
        : SliverToBoxAdapter(
            child: InfoBanner(
              infoText: ZOStrings.youCanDonate,
              infoValue: const DonationCountdownTimer(),
              buttonText: ZOStrings.callACourier,
              buttonIcon: Icons.directions_car_filled_outlined,
              onButtonPressed: () async {
                await _callACourier(context);
              },
            ),
          );
  }

  Future<void> _callACourier(BuildContext context) async {
    await DeliveryApiService().updateDeliveryStatus(
      context.read<DeliveryNotifier>().delivery!.internalId,
      ZOStrings.deliveryConfirmedState,
    );
    if (context.mounted) {
      context
          .read<DeliveryNotifier>()
          .updateDeliveryState(ZOStrings.deliveryConfirmedState);
    }
  }

  Widget _buildCards(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 154,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ZOCard(
              measuredValue:
                  OfferedFoodApiService().getSavedMealsCount(context: context),
              metricsText: ZOStrings.savedLunches,
              periodText: ZOStrings.total,
            ),
            const SizedBox(width: 14.0),
            ZOCard(
              measuredValue: OfferedFoodApiService().getSavedMealsCount(
                context: context,
                timePeriod: 30,
              ),
              metricsText: ZOStrings.savedLunches,
              periodText: ZOStrings.lastThirtyDays,
            ),
            const SizedBox(width: 14.0),
            ZOCard(
              measuredValue:
                  OfferedFoodApiService().getSavedMealsCount(context: context),
              metricsText: ZOStrings.savedLunches,
              periodText: ZOStrings.lastThirtyDays,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      itemsLimit: 5,
      filter:
          'darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
      title: ZOStrings.lastDonated,
    );
  }
}
