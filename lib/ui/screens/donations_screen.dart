import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/donated_food_list_info.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/donated_food_list.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final List<DonatedFoodListInfo> _donationsLists = [];

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
        title: Text(context.l10n!.donations),
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
                  title: context.l10n!.thisWeek,
                  additionalFilterField: 'weekNumber',
                  additionalFilterValue:
                      '${DateTime.now().year}-$currentWeekNumber',
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                DonatedFoodList(
                  title: context.l10n!.lastWeek,
                  additionalFilterField: 'weekNumber',
                  additionalFilterValue:
                      '${DateTime.now().year}-${HelperService.getCurrentWeekNumber - 1}',
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                for (var donatedFood in _donationsLists)
                  MultiSliver(
                    children: [
                      DonatedFoodList(
                        title: donatedFood.title,
                        additionalFilterField:
                            donatedFood.additionalFilterField,
                        additionalFilterValue:
                            donatedFood.additionalFilterValue,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: GapSize.xs),
                      ),
                    ],
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                SliverToBoxAdapter(
                  child: ZOButton(
                    text: context.l10n!.loadMore,
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
      desiredWeekNumber = Constants.lastWeekOfYear;
      year--;
    }

    setState(() {
      _donationsLists.add(
        DonatedFoodListInfo(
          title: HelperService.getScopeOfTheWeek(desiredWeekNumber, year),
          additionalFilterField: 'weekNumber',
          additionalFilterValue: '$year-$desiredWeekNumber',
        ),
      );
    });

    desiredWeekNumber--;
  }
}
