import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_movement_list.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class BoxesScreen extends StatefulWidget {
  const BoxesScreen({super.key});

  @override
  State<BoxesScreen> createState() => _BoxesScreenState();
}

class _BoxesScreenState extends State<BoxesScreen> {
  final List<DateTime> _previousWeeks = [];

  final DateTime _thisWeekStart = DateTimeUtils.getWeekStart(DateTime.now());
  late final DateTime _previousWeekStart =
      DateTimeUtils.getPreviousWeek(_thisWeekStart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.boxes),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            sliver: MultiSliver(
              children: [
                BoxMovementList(
                  title: context.l10n!.thisWeek,
                  deliveredFrom: _thisWeekStart,
                  deliveredTo: DateTimeUtils.getNextWeek(_thisWeekStart),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                BoxMovementList(
                  title: context.l10n!.lastWeek,
                  deliveredFrom: _previousWeekStart,
                  deliveredTo: DateTimeUtils.getNextWeek(_previousWeekStart),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                for (var weekStart in _previousWeeks)
                  MultiSliver(
                    children: [
                      BoxMovementList(
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
