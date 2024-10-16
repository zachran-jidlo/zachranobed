import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list_tile.dart';

class DonatedFoodList extends StatelessWidget {
  final int? itemsLimit;
  final DateTime? deliveredFrom;
  final DateTime? deliveredTo;
  final bool alwaysShowTitle;
  final String title;
  final _repository = GetIt.I<OfferedFoodRepository>();

  DonatedFoodList({
    Key? key,
    this.itemsLimit,
    this.deliveredFrom,
    this.deliveredTo,
    this.alwaysShowTitle = true,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<OfferedFood>>(
      stream: _repository.observeHistory(
        user: HelperService.getCurrentUser(context)!,
        limit: itemsLimit,
        from: deliveredFrom,
        to: deliveredTo,
      ),
      builder: (context, snapshot) {
        return MultiSliver(
          pushPinnedChildren: true,
          children: <Widget>[
            if (alwaysShowTitle || snapshot.data?.isNotEmpty == true)
              SliverPinnedHeader(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 8.0),
            Builder(
              builder: (context) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => DonatedFoodListTile(
                          offeredFood: snapshot.data!.toList()[index]),
                      childCount: snapshot.data!.length,
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
      },
    );
  }
}
