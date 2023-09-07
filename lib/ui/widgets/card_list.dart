import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/card.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final offeredFoodService = GetIt.I<OfferedFoodService>();
    final user = HelperService.getCurrentUser(context);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 154,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ZOCard(
              measuredValue: offeredFoodService.getSavedMealsCount(user: user!),
              metricsText: context.l10n!.savedLunches,
              periodText: context.l10n!.total,
            ),
            const SizedBox(width: GapSize.xxs),
            ZOCard(
              measuredValue: offeredFoodService.getSavedMealsCount(
                user: user,
                timePeriod: 30,
              ),
              metricsText: context.l10n!.savedLunches,
              periodText: context.l10n!.lastThirtyDays,
            ),
            const SizedBox(width: GapSize.xxs),
            ZOCard(
              measuredValue: offeredFoodService.getSavedMealsCount(user: user),
              metricsText: context.l10n!.savedLunches,
              periodText: context.l10n!.lastThirtyDays,
            ),
          ],
        ),
      ),
    );
  }
}
