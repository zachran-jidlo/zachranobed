import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:zachranobed/ui/widgets/floating_button.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZachranObedStrings.overview),
        actions: [
          IconButton(
            onPressed: () {
              print('Bell pressed');
            },
            icon: const Icon(MaterialSymbols.mail),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.clear();

              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(RouteManager.login);
              }
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildDonationCountdownTimer(context),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: MultiSliver(
              children: [
                _buildCards(context),
                _buildDonatedFoodList(context),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }

  Widget _buildDonationCountdownTimer(BuildContext context) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: ZachranObedStrings.youCanDonate,
        infoValue: const DonationCountdownTimer(),
        buttonText: ZachranObedStrings.callACourier,
        buttonIcon: Icons.directions_car_filled_outlined,
        onButtonPressed: () async {
          final deliveryService = DeliveryApiService();
          await deliveryService.updateDeliveryStatus(
            context.read<DeliveryNotifier>().delivery!.internalId,
            'Potvrzeno',
          );
        },
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 154,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ZachranObedCard(
              measuredValue:
                  OfferedFoodApiService().getSavedMealsCount(context: context),
              metricsText: ZachranObedStrings.savedLunches,
              periodText: ZachranObedStrings.total,
            ),
            const SizedBox(width: 15),
            ZachranObedCard(
              measuredValue: OfferedFoodApiService().getSavedMealsCount(
                context: context,
                timePeriod: 30,
              ),
              metricsText: ZachranObedStrings.savedLunches,
              periodText: ZachranObedStrings.lastThirtyDays,
            ),
            const SizedBox(width: 15),
            ZachranObedCard(
              measuredValue:
                  OfferedFoodApiService().getSavedMealsCount(context: context),
              metricsText: ZachranObedStrings.savedLunches,
              periodText: ZachranObedStrings.lastThirtyDays,
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
      title: ZachranObedStrings.lastDonated,
    );
  }
}
