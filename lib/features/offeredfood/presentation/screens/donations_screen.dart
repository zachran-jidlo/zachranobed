import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final List<DateTime> _previousWeeks = [];
  late Future<int> _mealsCountFuture;

  final DateTime _thisWeekStart = DateTimeUtils.getWeekStart(DateTime.now());
  late final DateTime _previousWeekStart = DateTimeUtils.getPreviousWeek(_thisWeekStart);

  @override
  void initState() {
    super.initState();
    final repository = GetIt.I<OfferedFoodRepository>();
    _mealsCountFuture = repository.getSavedMealsCount(
      user: HelperService.getCurrentUser(context)!,
      timePeriod: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: ZOAppBar(
        title: context.l10n!.food,
        automaticallyImplyLeading: false,
      ),
      child: FutureBuilder<int>(
        future: _mealsCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (snapshot.hasError) {
            return _buildError();
          } else {
            final mealsCount = snapshot.data!;
            return mealsCount < 1 ? _buildEmptyPage(context) : _buildContent(context);
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
          padding: const EdgeInsets.symmetric(horizontal: WidgetStyle.padding),
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
      child: EmptyPage(
        vectorImagePath: ZOStrings.chefEmptyPath,
        title: context.l10n!.donationsEmptyTitle,
        description: context.l10n!.donationsEmptyDescription,
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
