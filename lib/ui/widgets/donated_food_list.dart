import 'package:flutter/material.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/API_offered_food.dart';
import 'package:zachranobed/ui/widgets/donated_food_list_tile.dart';

class DonatedFoodList extends StatefulWidget {

  final int itemsLimit;

  const DonatedFoodList({
    Key? key,
    required this.itemsLimit,
  }) : super(key: key);

  @override
  State<DonatedFoodList> createState() => _DonatedFoodListState();
}

class _DonatedFoodListState extends State<DonatedFoodList> {

  late Future<List<OfferedFood>> futureOfferedFood;

  @override
  void initState() {
    super.initState();
    futureOfferedFood = APIofferedFood().getOfferedFoodList(widget.itemsLimit);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OfferedFood>>(
      future: futureOfferedFood,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DonatedFoodListTile(offeredFood: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      }
    );
  }
}
