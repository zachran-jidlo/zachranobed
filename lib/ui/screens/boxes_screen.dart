import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/box_movement_list_info.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/ui/widgets/box_movement_list.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class BoxesScreen extends StatefulWidget {
  const BoxesScreen({super.key});

  @override
  State<BoxesScreen> createState() => _BoxesScreenState();
}

class _BoxesScreenState extends State<BoxesScreen> {
  final List<BoxMovementListInfo> _boxMovementLists = [];

  var year = DateTime.now().year.toInt();
  final currentWeekNumber = HelperService.getCurrentWeekNumber;
  var desiredWeekNumber = 0;

  @override
  void initState() {
    super.initState();
    desiredWeekNumber = currentWeekNumber - _boxMovementLists.length - 2;
  }

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
                  weekNumber: '${DateTime.now().year}-$currentWeekNumber',
                  user: HelperService.getCurrentUser(context)!,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                BoxMovementList(
                  title: context.l10n!.lastWeek,
                  weekNumber: '${DateTime.now().year}-${currentWeekNumber - 1}',
                  user: HelperService.getCurrentUser(context)!,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GapSize.xs)),
                for (var boxMovement in _boxMovementLists)
                  MultiSliver(
                    children: [
                      BoxMovementList(
                        title: boxMovement.title,
                        weekNumber: boxMovement.weekNumber,
                        user: boxMovement.user,
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
                      _buildBoxMovementList(context);
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

  void _buildBoxMovementList(BuildContext context) {
    if (desiredWeekNumber <= 0) {
      desiredWeekNumber = Constants.lastWeekOfYear;
      year--;
    }

    setState(() {
      _boxMovementLists.add(
        BoxMovementListInfo(
          title: HelperService.getScopeOfTheWeek(desiredWeekNumber, year),
          weekNumber: '$year-$desiredWeekNumber',
          user: HelperService.getCurrentUser(context)!,
        ),
      );
    });

    desiredWeekNumber--;
  }
}
