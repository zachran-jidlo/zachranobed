import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';

int _LAST_WEEK_OF_YEAR = 52;

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
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
        title: Text(AppLocalizations.of(context)!.donations),
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
              horizontal: WidgetStyle.padding,
            ),
            sliver: MultiSliver(
              children: [
                DonatedFoodList(
                  title: AppLocalizations.of(context)!.thisWeek,
                  additionalFilterField: 'weekNumber',
                  additionalFilterValue:
                      '${DateTime.now().year}-${HelperService.getCurrentWeekNumber}',
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                DonatedFoodList(
                  title: AppLocalizations.of(context)!.lastWeek,
                  additionalFilterField: 'weekNumber',
                  additionalFilterValue:
                      '${DateTime.now().year}-${HelperService.getCurrentWeekNumber - 1}',
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                MultiSliver(
                  children: _donationsLists,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                SliverToBoxAdapter(
                  child: ZOButton(
                    text: AppLocalizations.of(context)!.loadMoreDonations,
                    icon: Icons.expand_more,
                    height: 40.0,
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
          title: HelperService.getScopeOfTheWeek(desiredWeekNumber, year),
          additionalFilterField: 'weekNumber',
          additionalFilterValue: 'cisloTydne(eq)$year-$desiredWeekNumber',
        ),
      );
    });

    desiredWeekNumber--;
  }
}
