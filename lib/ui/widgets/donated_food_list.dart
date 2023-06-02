import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

double _TITLE_ROW_HEIGHT = 40.0;

class DonatedFoodList extends StatefulWidget {
  final int itemsLimit;
  final String filter;
  final String title;
  final bool showServingsSum;

  const DonatedFoodList({
    Key? key,
    required this.itemsLimit,
    this.filter = '',
    required this.title,
    this.showServingsSum = false,
  }) : super(key: key);

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {
  final ValueNotifier<int> _servingsSum = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(
          child: Container(
            height: _TITLE_ROW_HEIGHT,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (widget.showServingsSum)
                  ValueListenableBuilder(
                    valueListenable: _servingsSum,
                    builder: (context, sum, child) {
                      return Text(
                        '${sum.toInt()} ks',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<OfferedFood>>(
          future: OfferedFoodApiService().getOfferedFoodList(
            limit: widget.itemsLimit,
            filter: widget.filter,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<OfferedFood> offers = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: offers.length,
                  (context, index) {
                    Future.delayed(Duration.zero, () {
                      _servingsSum.value +=
                          offers[index].foodInfo.numberOfServings!;
                    });
                    return DonatedFoodListTile(offeredFood: offers[index]);
                  },
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
