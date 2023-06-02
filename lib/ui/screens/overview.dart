import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/routes.dart';
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
                _buildCards(),
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

  Widget _buildCards() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 154,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const <Widget>[
            ZachranObedCard(
              metricsText: ZachranObedStrings.savedLunches,
              measuredVariableText: '1 223',
              periodText: ZachranObedStrings.total,
            ),
            SizedBox(width: 15),
            ZachranObedCard(
              metricsText: ZachranObedStrings.savedLunches,
              measuredVariableText: '270',
              periodText: ZachranObedStrings.lastThirtyDays,
            ),
            SizedBox(width: 15),
            ZachranObedCard(
              metricsText: ZachranObedStrings.savedLunches,
              measuredVariableText: '270',
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
