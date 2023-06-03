import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/donation_countdown_timer.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

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
          _buildDonationCountdownTimer(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: MultiSliver(
              children: [
                _buildCards(context),
                _buildDonatedFoodList(context),
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

  Widget _buildDonationCountdownTimer() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              DonationCountdownTimer(),
            ],
          ),
        ),
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
