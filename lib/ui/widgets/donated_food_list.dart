import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class DonatedFoodList extends StatefulWidget {
  final int? itemsLimit;
  final String? additionalFilterField;
  final dynamic additionalFilterValue;
  final String title;

  const DonatedFoodList({
    super.key,
    this.itemsLimit,
    this.additionalFilterField,
    this.additionalFilterValue,
    required this.title,
  });

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {
  final _offeredFoodService = GetIt.I<OfferedFoodService>();

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: GapSize.xs),
        StreamBuilder<List<OfferedFood>>(
          stream: _offeredFoodService.loggedUserOfferedFoodStream(
            user: HelperService.getCurrentUser(context)!,
            limit: widget.itemsLimit,
            additionalFilterField: widget.additionalFilterField,
            additionalFilterValue: widget.additionalFilterValue,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final offers = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: offers.length,
                  (context, index) {
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
