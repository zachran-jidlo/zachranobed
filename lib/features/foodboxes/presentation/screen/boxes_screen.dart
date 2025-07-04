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
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

class BoxesScreen extends StatefulWidget {
  const BoxesScreen({super.key});

  @override
  State<BoxesScreen> createState() => _BoxesScreenState();
}

class _BoxesScreenState extends State<BoxesScreen> {
  final List<DateTime> _previousWeeks = [];
  late Future<int> _boxMovementCountFuture;

  final DateTime _thisWeekStart = DateTimeUtils.getWeekStart(DateTime.now());
  late final DateTime _previousWeekStart = DateTimeUtils.getPreviousWeek(_thisWeekStart);

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
    return ScreenScaffold.universal(
      appBar: ZOAppBar(
        title: context.l10n!.boxes,
        automaticallyImplyLeading: false,
      ),
      child: FutureBuilder<int>(
        future: _boxMovementCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (snapshot.hasError) {
            return _buildError();
          } else {
            final boxCount = snapshot.data!;
            return boxCount < 1 ? _buildEmptyPage(context) : _buildContent(context);
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return const SingleChildScrollView(
      child: ErrorContent(onRetryPressed: null),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
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
                  minimumSize: ZOButtonSize.medium(),
                  type: ZOButtonType.secondary,
                  onPressed: _addPreviousWeek,
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }

  Widget _buildEmptyPage(BuildContext context) {
    return SingleChildScrollView(
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
                  minimumSize: ZOButtonSize.tiny(),
                  onPressed: () {
                    context.router.push(const OrderShippingOfBoxesRoute());
                  },
                ),
                const SizedBox(height: GapSize.xl),
              ],
            ),
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
