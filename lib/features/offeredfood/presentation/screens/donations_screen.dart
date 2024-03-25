import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final List<DateTime> _previousWeeks = [];

  final DateTime _thisWeekStart = DateTimeUtils.getWeekStart(DateTime.now());
  late final DateTime _previousWeekStart =
      DateTimeUtils.getPreviousWeek(_thisWeekStart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.food),
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
                  deliveredFrom: _thisWeekStart,
                  deliveredTo: DateTimeUtils.getNextWeek(_thisWeekStart),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                DonatedFoodList(
                  title: context.l10n!.lastWeek,
                  deliveredFrom: _previousWeekStart,
                  deliveredTo: DateTimeUtils.getNextWeek(_previousWeekStart),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                for (final weekStart in _previousWeeks)
                  MultiSliver(
                    children: [
                      DonatedFoodList(
                        title: DateTimeUtils.getTitleForWeek(weekStart),
                        deliveredFrom: weekStart,
                        deliveredTo: DateTimeUtils.getNextWeek(weekStart),
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
                    type: ZOButtonType.secondary,
                    onPressed: _addPreviousWeek,
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

  void _addPreviousWeek() {
    setState(() {
      if (_previousWeeks.isEmpty) {
        _previousWeeks.add(DateTimeUtils.getPreviousWeek(_previousWeekStart));
      } else {
        _previousWeeks.add(DateTimeUtils.getPreviousWeek(_previousWeeks.last));
      }
    });
  }
}
