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
          return _table(context, boxes);
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Creates a table widget containing statistics of food boxes.
  ///
  /// The [FittedBox] ensures the table is scaled down if it exceeds the width
  /// constraint on smaller screen sizes. [LayoutBuilder] with
  /// [ConstrainedBox] are used to propagate all available width as a minimum
  /// width for the table content, so that on larger screen sizes the first
  /// column could occupy all remaining width.
  Widget _table(BuildContext context, Iterable<FoodBoxStatistics> boxes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ZOColors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: _tableContent(context, boxes),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tableContent(
    BuildContext context,
    Iterable<FoodBoxStatistics> boxes,
  ) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      columnWidths: const <int, TableColumnWidth>{
        // Makes the first column to occupy all remaining width
        0: IntrinsicColumnWidth(flex: 1.0),
      },
      children: [
        TableRow(children: [
          _header(context.l10n!.box),
          _header(context.l10n!.total),
          _header(context.l10n!.charity),
          _header(context.l10n!.canteen),
        ]),
        ...boxes.map((box) {
          return TableRow(children: [
            _cell(box.type.name),
            _cell(box.totalQuantity.toString()),
            _cell(box.quantityAtCharity.toString()),
            _cell(box.quantityAtCanteen.toString()),
          ]);
        }).toList()
      ],
    );
  }

  Widget _header(String text) {
    return _cell(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _cell(String text, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
