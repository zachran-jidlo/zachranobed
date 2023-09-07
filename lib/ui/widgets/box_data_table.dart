import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/box.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/box_service.dart';
import 'package:zachranobed/shared/constants.dart';

class BoxDataTable extends StatelessWidget {
  final UserData user;

  const BoxDataTable({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final boxService = GetIt.I<BoxService>();

    return StreamBuilder<List<Box>>(
      stream: boxService.loggedUserBoxesStream(
          establishmentId: user.establishmentId),
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
              columns: [
                DataColumn(
                    label: Text(
                  context.l10n!.boxType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.total,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.atCharity,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  context.l10n!.atCanteen,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
              rows: boxes.map((box) {
                return DataRow(cells: [
                  DataCell(Text(box.boxType)),
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
