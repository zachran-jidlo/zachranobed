import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/models/user_data.dart';

class BoxDataTable extends StatelessWidget {
  final UserData user;

  const BoxDataTable({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final repository = GetIt.I<FoodBoxRepository>();

    return StreamBuilder<Iterable<FoodBoxStatistics>>(
      stream: repository.observeStatistics(user.entityId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final boxes = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: ZOColors.borderColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: DataTable(
              columnSpacing: 10.0,
              headingRowHeight: 35.0,
              dataRowMinHeight: 10.0,
              dataRowMaxHeight: 35.0,
              columns: [
                DataColumn(
                    label: Text(
                  context.l10n!.box,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.total,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.charity,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.canteen,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
              rows: boxes.map((box) {
                return DataRow(cells: [
                  DataCell(Text(box.type.name)),
                  DataCell(Text(box.totalQuantity.toString())),
                  DataCell(Text(box.quantityAtCharity.toString())),
                  DataCell(Text(box.quantityAtCanteen.toString())),
                ]);
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
