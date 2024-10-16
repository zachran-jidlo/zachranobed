import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_movement_list.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_page.dart';
import 'package:zachranobed/ui/widgets/loading_page.dart';

class BoxesScreen extends StatefulWidget {
  const BoxesScreen({super.key});

  @override
  State<BoxesScreen> createState() => _BoxesScreenState();
}

class _BoxesScreenState extends State<BoxesScreen> {
  final List<DateTime> _previousWeeks = [];
  late Future<int> _boxMovementCountFuture;

  final DateTime _thisWeekStart = DateTimeUtils.getWeekStart(DateTime.now());
  late final DateTime _previousWeekStart =
      DateTimeUtils.getPreviousWeek(_thisWeekStart);

  @override
  void initState() {
    super.initState();
    final repository = GetIt.I<FoodBoxRepository>();
    _boxMovementCountFuture = repository.getMovementBoxesCount(
      user: HelperService.getCurrentUser(context)!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = context.l10n!.boxes;
    return FutureBuilder<int>(
      future: _boxMovementCountFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage(pageTitle: pageTitle);
        } else if (snapshot.hasError) {
          return ErrorPage(
            pageTitle: pageTitle,
            error: snapshot.error,
          );
        } else {
          final boxCount = snapshot.data!;
          return boxCount < 1
              ? _buildEmptyPage(context)
              : _buildContent(context);
        }
      },
    );
  }

  Widget _buildContent(BuildContext context) {
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

  Widget _buildEmptyPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n!.boxes)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EmptyPage(
              vectorImagePath: ZOStrings.boxEmptyPath,
              title: context.l10n!.boxesEmptyTitle,
              description: context.l10n!.boxesEmptyDescription,
            ),
            if (HelperService.getCurrentUser(context) is Charity)
              Column(
                children: [
                  ZOButton(
                    text: context.l10n!.orderShipping,
                    fullWidth: false,
                    onPressed: () {
                      context.router.push(const OrderShippingOfBoxesRoute());
                    },
                  ),
                  const SizedBox(height: GapSize.xl),
                ],
              ),
          ],
        ),
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
