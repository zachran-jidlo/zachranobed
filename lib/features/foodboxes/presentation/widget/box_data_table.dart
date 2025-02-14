import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';

class BoxDataTable extends StatelessWidget {
  final Iterable<FoodBoxStatistics> boxes;
  final bool alertColors;
  final List<BoxDataTableColumn> focusedColumns;

  const BoxDataTable({
    super.key,
    required this.boxes,
    required this.alertColors,
    this.focusedColumns = BoxDataTableColumn.values,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: alertColors
          ? BoxDecoration(
              color: ZOColors.secondary,
              border: Border.all(width: 1, color: ZOColors.primary),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            )
          : BoxDecoration(
              border: Border.all(width: 1, color: ZOColors.borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            /// The [FittedBox] ensures the table is scaled down if it exceeds the width
            /// constraint on smaller screen sizes. [LayoutBuilder] with
            /// [ConstrainedBox] are used to propagate all available width as a minimum
            /// width for the table content, so that on larger screen sizes the first
            /// column could occupy all remaining width.
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
          _header(context, BoxDataTableColumn.name),
          _header(context, BoxDataTableColumn.total),
          _header(context, BoxDataTableColumn.charity),
          _header(context, BoxDataTableColumn.canteen),
        ]),
        ...boxes.map((box) {
          return TableRow(children: [
            _value(box, BoxDataTableColumn.name),
            _value(box, BoxDataTableColumn.total),
            _value(box, BoxDataTableColumn.charity),
            _value(box, BoxDataTableColumn.canteen),
          ]);
        }).toList()
      ],
    );
  }

  Widget _header(BuildContext context, BoxDataTableColumn column) {
    final text = column.header(context);
    final color = _getColumnColor(column);
    return _cell(text, style: TextStyle(fontWeight: FontWeight.bold, color: color));
  }

  Widget _value(FoodBoxStatistics box, BoxDataTableColumn column) {
    final text = column.value(box);
    final color = _getColumnColor(column);
    return _cell(text, style: TextStyle(color: color));
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

  Color _getColumnColor(BoxDataTableColumn column) {
    final focused = focusedColumns.contains(column);
    return focused ? Colors.black : ZOColors.outline;
  }
}

/// Enumeration of available columns in [BoxDataTable].
enum BoxDataTableColumn {
  name,
  total,
  charity,
  canteen;

  /// Returns a header for the column.
  String header(BuildContext context) {
    switch (this) {
      case BoxDataTableColumn.name:
        return context.l10n!.box;
      case BoxDataTableColumn.total:
        return context.l10n!.total;
      case BoxDataTableColumn.charity:
        return context.l10n!.charity;
      case BoxDataTableColumn.canteen:
        return context.l10n!.canteen;
    }
  }

  /// Returns a value for the column for the given box statistics.
  String value(FoodBoxStatistics box) {
    switch (this) {
      case BoxDataTableColumn.name:
        return box.type.name;
      case BoxDataTableColumn.total:
        return box.totalQuantity.toString();
      case BoxDataTableColumn.charity:
        return box.quantityAtCharity.toString();
      case BoxDataTableColumn.canteen:
        return box.quantityAtCanteen.toString();
    }
  }
}
