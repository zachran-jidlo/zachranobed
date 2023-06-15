import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';

class Donations extends StatelessWidget {
  const Donations({super.key});

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
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: 'Tento týden',
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                DonatedFoodList(
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber - 1},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: 'Minulý týden',
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}
