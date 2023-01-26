import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/API_offered_food.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class DonatedFoodList extends StatefulWidget {

  final int itemsLimit;
  final String title;
  final bool showServingsSum;

  const DonatedFoodList({
    Key? key,
    required this.itemsLimit,
    required this.title,
    this.showServingsSum = false,
  }) : super(key: key);

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {

  late Future<List<OfferedFood>> futureOfferedFood;
  late ValueNotifier<int> servingsSum = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    futureOfferedFood = APIofferedFood().getOfferedFoodList(widget.itemsLimit);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (widget.showServingsSum)
              ValueListenableBuilder(
                valueListenable: servingsSum,
                builder: (context, sum, child) {
                  return Text(
                    '${sum.toInt()} ks',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
          ],
        ),
        FutureBuilder<List<OfferedFood>>(
          future: futureOfferedFood,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<OfferedFood> offers = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  Future.delayed(Duration.zero, () {
                    servingsSum.value += offers[index].numberOfServings;
                  });
                  return DonatedFoodListTile(offeredFood: offers[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        ),
      ],
    );
  }
}
