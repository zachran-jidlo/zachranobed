import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/ui/widgets/card.dart';

class CardList extends StatelessWidget {
  final UserData user;

  const CardList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final repository = GetIt.I<OfferedFoodRepository>();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 154,
        child: Row(
          children: [
            Expanded(
              child: ZOCard(
                measuredValue:
                    repository.getSavedMealsCount(entityId: user.entityId),
                metricsText: context.l10n!.savedLunches,
                periodText: context.l10n!.total,
              ),
            ),
            const SizedBox(width: GapSize.xxs),
            Expanded(
              child: ZOCard(
                measuredValue: repository.getSavedMealsCount(
                  entityId: user.entityId,
                  timePeriod: 30,
                ),
                metricsText: context.l10n!.savedLunches,
                periodText: context.l10n!.lastThirtyDays,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
