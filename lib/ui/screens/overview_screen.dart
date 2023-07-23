import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';

class OverviewScreen extends StatelessWidget {
  final _deliveryService = GetIt.I<DeliveryService>();
  final _offeredFoodService = GetIt.I<OfferedFoodService>();

  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.overview),
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
                _buildCards(context),
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

    if (!HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return deliveryConfirmed
        ? SliverToBoxAdapter(
            child: InfoBanner(
              infoText: AppLocalizations.of(context)!.courierWillCome,
              infoValue: Text(
                '${user!.pickUpFrom} a ${user.pickUpWithin}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s,
                  color: ZOColors.onPrimaryLight,
                ),
              ),
              buttonText: AppLocalizations.of(context)!.contactCarrier,
              buttonIcon: Icons.phone_outlined,
              onButtonPressed: () async =>
                  await HelperService.makePhoneCall('123456789'),
            ),
          )
        : SliverToBoxAdapter(
            child: InfoBanner(
              infoText: AppLocalizations.of(context)!.youCanDonate,
              infoValue: const DonationCountdownTimer(),
              buttonText: AppLocalizations.of(context)!.callACourier,
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
      AppLocalizations.of(context)!.deliveryConfirmedState,
    );
    if (context.mounted) {
      context.read<DeliveryNotifier>().updateDeliveryState(
          AppLocalizations.of(context)!.deliveryConfirmedState);
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
                  _offeredFoodService.getSavedMealsCount(context: context),
              metricsText: AppLocalizations.of(context)!.savedLunches,
              periodText: AppLocalizations.of(context)!.total,
            ),
            const SizedBox(width: GapSize.xxs),
            ZOCard(
              measuredValue: _offeredFoodService.getSavedMealsCount(
                context: context,
                timePeriod: 30,
              ),
              metricsText: AppLocalizations.of(context)!.savedLunches,
              periodText: AppLocalizations.of(context)!.lastThirtyDays,
            ),
            const SizedBox(width: GapSize.xxs),
            ZOCard(
              measuredValue:
                  _offeredFoodService.getSavedMealsCount(context: context),
              metricsText: AppLocalizations.of(context)!.savedLunches,
              periodText: AppLocalizations.of(context)!.lastThirtyDays,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: AppLocalizations.of(context)!.lastDonated,
      itemsLimit: 5,
    );
  }
}
