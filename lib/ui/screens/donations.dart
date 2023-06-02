import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/floating_button.dart';

class Donations extends StatelessWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZachranObedStrings.donations),
        actions: [
          IconButton(
            onPressed: () {
              print('Kliknuto na hledat');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: MultiSliver(
              children: [
                DonatedFoodList(
                  itemsLimit: 1000,
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: 'Tento týden',
                  showServingsSum: true,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                DonatedFoodList(
                  itemsLimit: 1000,
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber - 1},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: 'Minulý týden',
                  showServingsSum: true,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
      floatingActionButton: ZachranObedFloatingButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(RouteManager.offerFood),
      ),
    );
  }
}
