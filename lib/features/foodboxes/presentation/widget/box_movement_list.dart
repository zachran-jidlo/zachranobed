import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_movement_list_tile.dart';

class BoxMovementList extends StatelessWidget {
  final String title;
  final DateTime deliveredFrom;
  final DateTime deliveredTo;

  const BoxMovementList({
    super.key,
    required this.title,
    required this.deliveredFrom,
    required this.deliveredTo,
  });

  @override
  Widget build(BuildContext context) {
    final repository = GetIt.I<FoodBoxRepository>();

    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: GapSize.xs),
        StreamBuilder<Iterable<BoxMovement>>(
          stream: repository.observeHistory(
            entityId: HelperService.getCurrentUser(context)!.entityId,
            from: deliveredFrom,
            to: deliveredTo,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movements = snapshot.data!.toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: movements.length,
                  (context, index) => BoxMovementListTile(
                    boxMovement: movements[index],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
