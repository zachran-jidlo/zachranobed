import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class DonatedFoodList extends StatefulWidget {
  final int? itemsLimit;
  final String filter;
  final String title;

  const DonatedFoodList({
    super.key,
    this.itemsLimit,
    this.filter = '',
    required this.title,
  });

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {
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
        const SizedBox(height: 16.0),
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
