import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';

int _LAST_WEEK_OF_YEAR = 52;

class Donations extends StatefulWidget {
  const Donations({super.key});

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  final List<Widget> _donationsLists = [];

  var year = DateTime.now().year.toInt();
  final currentWeekNumber = HelperService.getCurrentWeekNumber;
  var desiredWeekNumber = 0;

  @override
  void initState() {
    super.initState();
    desiredWeekNumber = currentWeekNumber - _donationsLists.length - 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZOStrings.donations),
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
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.horizontalPadding,
            ),
            sliver: MultiSliver(
              children: [
                DonatedFoodList(
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: ZOStrings.thisWeek,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                DonatedFoodList(
                  filter:
                      'cisloTydne(eq)${DateTime.now().year}-${HelperService.getCurrentWeekNumber - 1},darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
                  title: ZOStrings.lastWeek,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                MultiSliver(
                  children: _donationsLists,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: ZOButton(
                    text: ZOStrings.loadMoreDonations,
                    icon: Icons.expand_more,
                    height: 40,
                    isSecondary: true,
                    onPressed: () {
                      _buildDonationsList(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  void _buildDonationsList(BuildContext context) {
    if (desiredWeekNumber <= 0) {
      desiredWeekNumber = _LAST_WEEK_OF_YEAR;
      year--;
    }

    setState(() {
      _donationsLists.add(
        DonatedFoodList(
          filter:
              'cisloTydne(eq)$year-$desiredWeekNumber,darce.id(eq)${HelperService.getCurrentUser(context)!.internalId}',
          title: HelperService.getScopeOfTheWeek(desiredWeekNumber, year),
        ),
      );
    });

    desiredWeekNumber--;
  }
}
